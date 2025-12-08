import SwiftUI
import Supabase // TODO: Remove
import FactoryKit

struct SignInViewV2: View {
    @State private var vm: ViewModel
    @Environment(SessionManager.self) var appSessionVm
    @FocusState private var fieldFocus: FocusedField?
    @State private var animationAmount = 1.0
    
    enum FocusedField {
        case email, password
    }
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            animatedFootball
                .padding(.bottom, 16)
            
            Spacer(minLength: 40)
            
            appTitle
            
            VStack(spacing: 10) {
                emailField
                    .padding(.bottom, 5)
                
                passwordField
                    .padding(.bottom, 40)
                
                enableFaceId
                    .padding(.bottom, 15)
                
                HStack {
                    signInButton
                    signInFaceIdButton
                        .padding(.leading)
                }
                
                Spacer()
            }
            .padding(.top, 40)
            
            Spacer()
        }
        .foregroundStyle(.offWhite)
        .navigationDestination(isPresented: $vm.showForgotPassword, destination: {
            ForgotPasswordView()
        })
        .padding()
        .frame(maxWidth: .infinity)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
    }
    
    private var animatedFootball: some View {
        Image(systemName: "football.fill")
            .font(.system(size: 60))
            .foregroundStyle(.offWhite)
            .rotation3DEffect(
                .degrees(animationAmount),
                axis: (x: 0.5, y: -0.5, z: 0),
                perspective: 0.6
            )
            .animation(.easeIn(duration: 10)
                .repeatForever(autoreverses: true),
                value: animationAmount
            )
    }
    
    private var appTitle: some View {
        Text("College Fantasy Football")
            .foregroundStyle(.offWhite)
            .font(.largeTitle.bold())
            .multilineTextAlignment(.center)
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Email")
                .font(.callout.bold())
                .padding(.leading, 5)
            
            TextField("Email", text: $vm.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .defaultTextFieldStyle()
                .submitLabel(.next)
                .focused($fieldFocus, equals: .email)
                .onSubmit { fieldFocus = .password }
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Password")
                .font(.callout.bold())
                .padding(.leading, 5)
            
            SecureField("Password", text: $vm.password)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .textContentType(.password)
                .autocorrectionDisabled()
                .foregroundStyle(.offWhite)
                .defaultTextFieldStyle()
                .submitLabel(.continue)
                .focused($fieldFocus, equals: .password)
                .onSubmit {
                    fieldFocus = nil
                    Task { await vm.signInEmailPasswordButtonTapped() }
                }
        }
    }
    
    private var signInButton: some View {
        Button {
            Task { await vm.signInEmailPasswordButtonTapped() }
        } label: {
            Text(vm.DEFAULT_SIGN_IN_BUTTON_TEXT)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.20, green: 0.48, blue: 1.0))
                .clipShape(.buttonBorder)
                .font(.headline)
                .opacity(1.0)
        }
        .disabled(vm.disableSignInButton)
    }
    
    private var signInFaceIdButton: some View {
        Button {
            Task {
                await vm.signInFaceIdTapped()
            }
        } label: {
            Image(systemName: "faceid")
                .resizable()
                .frame(height: 35)
                .frame(width: 35)
                .foregroundStyle(vm.enableFaceId ? .blue : .gray)
                .background(.clear)
        }
        .disabled(!vm.enableFaceId)
    }
    
    private var enableFaceId: some View {
        HStack {
            Image(systemName: "faceid")
            Toggle("Enable FaceID?", isOn: $vm.enableFaceId)
        }
    }
}

#Preview {
    let _ = Container
        .shared
        .authService
        .register { MockAuthService() }
    
    let _ = Container
        .shared
        .logger
        .register { LoggingService() }
    
    let vm = SignInViewV2.ViewModel()
    
    NavigationStack {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            SignInViewV2(vm: vm)
        }
    }
}
