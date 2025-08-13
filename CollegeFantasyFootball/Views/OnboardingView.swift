//
//  ImprovedTabView.swift
//  CollegeFantasyFootball
//
//  Enhanced version with better UX
//

import SwiftUI

struct OnboardingView: View {
    @State private var selection = 0
    @State private var showSkipButton = true
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    let tabCount = 6

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                welcomeTab
                    .tag(0)
                developmentTab
                    .tag(1)
                featuresTab
                    .tag(2)
                signingDayTab
                    .tag(3)
                seasonTab
                    .tag(4)
                thankYouTab
                    .tag(5)
            }
            .tabViewStyle(.page)
            .onAppear {
                setupTabViewAppearance()
            }
            
            VStack {
                HStack {
                    Spacer()
                    if showSkipButton {
                        skipButton
                            .padding(.top, 50)
                            .padding(.trailing, 20)
                    }
                }
                
                Spacer()
                
                if selection < tabCount - 1 {
                    nextButton
                        .padding(.trailing, 20)
                        .padding(.bottom, 40)
                }
            }
        }
        .onChange(of: selection) { _ in
            // Hide skip button on last tab
            showSkipButton = selection < tabCount - 1
        }
    }
    
    // MARK: - Tab Views
    
    private var welcomeTab: some View {
        ScrollView {
            VStack(spacing: 30) {
                // App icon or logo placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue.gradient)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "football")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    )
                
                VStack(spacing: 16) {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Group {
                        Text("Swipe right to learn more about ")
                            .font(.title3)
                        +
                        Text("College Fantasy Football")
                            .font(.title3)
                            .italic()
                            .fontWeight(.semibold)
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
        }
    }
    
    private var developmentTab: some View {
        ScrollView {
            VStack(spacing: 25) {
                Image(systemName: "hammer.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                VStack(spacing: 20) {
                    Group {
                        Text("College Fantasy Football")
                            .italic()
                            .bold()
                        +
                        Text(" is undergoing active development and will continue to receive several updates throughout the season.")
                    }
                    .font(.body)
                    .multilineTextAlignment(.center)
                    
                    Text("Please join the Discord for personal updates from the developer, quick fix requests, and to stay up-to-date on all things related to the app.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    joinDiscordButton
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
        }
    }
    
    private var featuresTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                VStack(spacing: 16) {
                    Image(systemName: "list.bullet.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("Current Features")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Group {
                            Text("Fantasy leagues currently contain players from the ")
                            +
                            Text("Big Ten")
                                .bold()
                            +
                            Text(" conference.")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.purple)
                            Text("Required positions in each lineup:")
                                .fontWeight(.semibold)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(["QB - Quarterback", "RB - Running Back", "TE - Tight End", "WR - Wide Receiver", "FLEX - (RB, TE, WR)"], id: \.self) { position in
                                HStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 6, height: 6)
                                    Text(position)
                                        .font(.subheadline)
                                }
                                .padding(.leading, 20)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.gray)
                            Group {
                                Text("Configurable positions in ")
                                +
                                Text("league settings")
                                    .italic()
                                    .fontWeight(.semibold)
                                +
                                Text(":")
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(["P - Punter", "PK - Place Kicker"], id: \.self) { position in
                                HStack {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 6, height: 6)
                                    Text(position)
                                        .font(.subheadline)
                                }
                                .padding(.leading, 20)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
        }
    }
    
    private var signingDayTab: some View {
        ScrollView {
            VStack(spacing: 25) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Signing Day")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            Image(systemName: "equal.circle.fill")
                                .foregroundColor(.orange)
                                .padding(.top, 2)
                            Group {
                                Text("Equivalent to a draft, ")
                                +
                                Text("Signing Day")
                                    .italic()
                                    .fontWeight(.semibold)
                                +
                                Text(" consists of ")
                                +
                                Text("ten rounds")
                                    .bold()
                                +
                                Text(" using the snake draft algorithm.")
                            }
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .foregroundColor(.green)
                                .padding(.top, 2)
                            Text("Users can filter by school and/or position to quickly find their player during Signing Day.")
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(.yellow)
                                .padding(.top, 2)
                            Group {
                                Text("Find a player you like? Add them to your ")
                                +
                                Text("Prospect")
                                    .italic()
                                    .fontWeight(.semibold)
                                +
                                Text(" (draft board) list.")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
        }
    }
    
    private var seasonTab: some View {
        ScrollView {
            VStack(spacing: 25) {
                Image(systemName: "calendar.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("The Season")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack(alignment: .top) {
                        Image(systemName: "clock.circle.fill")
                            .foregroundColor(.blue)
                            .padding(.top, 2)
                        Group {
                            Text("Each ")
                            +
                            Text("College Fantasy Football")
                                .bold()
                                .italic()
                            +
                            Text(" season currently consists of ")
                            +
                            Text("10 weeks")
                                .bold()
                            +
                            Text(" and will be configurable -- along with playoffs -- in a future update.")
                            +
                            Text("Live game stats will be available in a later update. For now, game stats will be updated by the end of each game day.")
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
        }
    }
    
    private var thankYouTab: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                VStack(spacing: 20) {
                    Text("Thank You")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Group {
                        Text("The ")
                        +
                        Text("College Fantasy Football")
                            .bold()
                            .italic()
                        +
                        Text(" development team thanks you for choosing to download this app.")
                    }
                    .font(.body)
                    .multilineTextAlignment(.center)
                    
                    Group {
                        Text("Your patience is greatly appreciated in this app's ")
                        +
                        Text("first")
                            .bold()
                        +
                        Text(" inaugural season.")
                    }
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    
                    Button("Get Started") {
                        completeOnboarding()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.top, 20)
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
        }
    }
    
    // MARK: - UI Components
    
    private var skipButton: some View {
        Button("Skip") {
            completeOnboarding()
        }
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundColor(.blue)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(20)
    }
    
    private var nextButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                if selection < tabCount - 1 {
                    selection += 1
                }
            }
        }) {
            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: selection)
    }
    
    private var joinDiscordButton: some View {
        Button(action: {
            if let url = URL(string: Secrets.DISCORD_URL_STR) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(spacing: 12) {
                Image("Discord-Symbol-White")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text("Join Discord")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(Color(red: 88/255, green: 101/255, blue: 242/255))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: false)
    }
    
    // MARK: - Methods
    
    private func setupTabViewAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.systemBlue
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray4
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}

// MARK: - Custom Button Style

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .background(Color.blue)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    OnboardingView()
}
