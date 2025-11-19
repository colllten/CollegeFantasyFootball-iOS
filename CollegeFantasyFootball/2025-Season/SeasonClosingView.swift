//
//  SeasonClosingView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 11/3/25.
//

import SwiftUI

struct SeasonClosingView: View {
    @State private var selection = 0
    
    let tabCount = 4

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                introTab
                    .tag(0)
                developmentTab
                    .tag(1)
                featuresTab
                    .tag(2)
                thankYouTab
                    .tag(3)
            }
            .tabViewStyle(.page)
            .onAppear {
                setupTabViewAppearance()
            }
        }
    }
    
    // MARK: - Tab Views
    
    private var introTab: some View {
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
                    Text("Thank you!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Group {
                        Text("Swipe right to learn more about the 2026 season of ")
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
                        Text(" will be rigorously improved during its offseason (now) to provide a more native fantasy football experience in a collegiate setting.")
                    }
                    .font(.body)
                    .multilineTextAlignment(.center)
                    
                    Text("Please join the Discord to stay up-to-date on all things related to the app.")
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
                    
                    Text("2026 Features")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "4.alt.square")
                            .foregroundColor(.blue)
                        Group {
                            Text("All offensive players from Power 4 conferences")
                        }
                    }
                    
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.purple)
                        Text("Longer fantasy season with playoffs")
                    }
                    
                    HStack {
                        Image(systemName: "book.pages")
                            .foregroundColor(.green)
                        Text("Player past performance")
                    }
                    
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.gray)
                        Text("Projected player performance")
                    }
                    
                    HStack {
                        Image(systemName: "medal.fill")
                            .foregroundColor(.orange)
                        Text("Fantasy league records, stats, and more")
                    }
                    
                    HStack {
                        Image(systemName: "gearshape")
                            .foregroundColor(.black)
                        Text("Auto draft capabilities")
                    }
                    
                    HStack {
                        Image(systemName: "arrow.left.arrow.right")
                            .foregroundColor(.brown)
                        Text("Player trades")
                    }
                    
                    HStack {
                        Image(systemName: "pencil.and.outline")
                            .foregroundColor(.mint)
                        Text("Profile customization")
                    }
                    
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.red)
                        Text("Push notifications")
                    }
                    
                    HStack {
                        Image(systemName: "hand.tap")
                            .foregroundColor(.teal)
                        Text("UI, UX, and general performance and stability improvements")
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
                        Text(" development team appreciates your participation in the app's first annual season.")
                    }
                    .font(.body)
                    .multilineTextAlignment(.center)
                    
                    Group {
                        Text("We look forward to seeing you in August 2026!")
                    }
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.7)
        }
    }
    
    // MARK: - UI Components
    
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
}

#Preview {
    SeasonClosingView()
}
