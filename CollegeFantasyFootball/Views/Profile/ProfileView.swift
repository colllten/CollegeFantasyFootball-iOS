//
//  ProfileView.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/12/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Profile Header Section
                profileHeaderSection
                
                // Issue Reporting Section
                issueReportingSection
                
                // Action Buttons Section
                actionButtonsSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreditsView()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.loadData()
        }
        .withLoading(vm.isLoading)
        .alert(vm.alertMessage, isPresented: $vm.showAlert) { }
    }
    
    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
        VStack(spacing: 20) {
            // Profile Avatar with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // User Information
            VStack(spacing: 8) {
                if let firstName = vm.user.firstName,
                   let lastName = vm.user.lastName {
                    Text("\(firstName) \(lastName)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Text("@\(vm.user.username)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.secondary.opacity(0.1))
                    )
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }
    
    // MARK: - Issue Reporting Section
    private var issueReportingSection: some View {
        VStack(spacing: 20) {
            // Section Header
            HStack {
                Image(systemName: "exclamationmark.bubble.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                
                Text("Report an Issue")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Character count with color coding
                Text("\(vm.ISSUE_TEXT_MAX_LEN - vm.issueText.count)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(characterCountColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(characterCountColor.opacity(0.1))
                    )
            }
            
            // Text Editor with improved styling
            VStack(alignment: .leading, spacing: 8) {
                TextEditor(text: $vm.issueText)
                    .frame(minHeight: 120)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .keyboardType(.asciiCapable)
                
                // Helper text
                Text("Submitting this issue will also send recent app logs to help us debug your report.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            // Submit Button
            Button {
                Task {
                    await vm.submitIssuePressed()
                }
            } label: {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Submit Issue")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(vm.issueText.trimmingCharacters(in: .whitespacesAndNewlines).count < vm.ISSUE_TEXT_MIN_LEN)
            .opacity(vm.issueText.trimmingCharacters(in: .whitespacesAndNewlines).count < vm.ISSUE_TEXT_MIN_LEN ? 0.6 : 1.0)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            signOutButton
            deleteAccountButton
        }
    }
    
    // MARK: - Computed Properties
    private var characterCountColor: Color {
        let remaining = vm.ISSUE_TEXT_MAX_LEN - vm.issueText.count
        if remaining < 50 {
            return .red
        } else if remaining < 100 {
            return .orange
        } else {
            return .secondary
        }
    }
    
    private var borderColor: Color {
        if vm.issueText.count > vm.ISSUE_TEXT_MAX_LEN {
            return .red
        } else if vm.issueText.count > vm.ISSUE_TEXT_MAX_LEN - 50 {
            return .orange
        } else {
            return .secondary.opacity(0.3)
        }
    }
    
    private var profileCompleteness: String {
        let hasFirstName = vm.user.firstName != nil && !vm.user.firstName!.isEmpty
        let hasLastName = vm.user.lastName != nil && !vm.user.lastName!.isEmpty
        let hasUsername = !vm.user.username.isEmpty
        
        let completedFields = [hasFirstName, hasLastName, hasUsername].filter { $0 }.count
        let totalFields = 3
        
        if completedFields == totalFields {
            return "Complete"
        } else {
            return "\(completedFields)/\(totalFields)"
        }
    }
    
    // MARK: - Action Buttons
    private var signOutButton: some View {
        Button {
            Task {
                let signOutSuccess = await vm.signOutButtonPressed()
                if signOutSuccess {
                    dismiss()
                }
            }
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign Out")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.orange, .orange.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
    
    private var deleteAccountButton: some View {
        Button {
            Task {
                let success = await vm.deleteAccountButtonPressed()
                if success {
                    dismiss()
                }
            }
        } label: {
            HStack {
                Image(systemName: "trash.fill")
                Text("Delete Account")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.red, .red.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(vm: ProfileViewModel())
    }
}
