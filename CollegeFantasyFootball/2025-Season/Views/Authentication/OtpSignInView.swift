//
//  OtpSignInView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 9/1/25.
//

import SwiftUI

struct OtpSignInView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = OtpSignInViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("OTP Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter your email to receive a one-time sign-in code.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 20) {
                TextField("Email", text: $vm.emailText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .disabled(vm.showEnterOtp)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                if vm.showEnterOtp {
                    withAnimation(.easeInOut) {
                        TextField("One-Time Code", text: $vm.otpText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
            
            Button(action: {
                Task {
                    if vm.showEnterOtp {
                        await vm.verifyOtpPressed()
                    } else {
                        await vm.submitOtpPressed()
                    }
                }
            }) {
                Text(vm.showEnterOtp ? "Verify Code" : "Send Code")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
                    .shadow(radius: 4, y: 2)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 40)
        .onChange(of: vm.dismiss) { _, _ in
            dismiss()
        }
        .alert(vm.alertMessage, isPresented: $vm.showAlert) {}
        .withLoading(vm.isLoading)
    }
}

#Preview {
    OtpSignInView()
}

