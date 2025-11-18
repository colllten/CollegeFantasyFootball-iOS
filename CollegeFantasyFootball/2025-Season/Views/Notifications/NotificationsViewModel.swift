//
//  NotificationsViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/21/25.
//

import Foundation

class NotificationsViewModel: BaseViewModel {
    @Published var allLeagueInvites = [FantasyLeagueInviteDto]()
    var unansweredLeagueInvites: [FantasyLeagueInviteDto] {
        return allLeagueInvites.filter { invite in
            invite.accepted == nil
        }
    }
    
//    let userId = UserDefaults.standard.string(forKey: "userId")!
    
    public func loadData() async {
        LoggingManager
            .logInfo("Loading data for NotificationsView")
        
        isLoading = true
        do {
            allLeagueInvites = try await fetchLeagueInvites()
        } catch {
            LoggingManager
                .logError("Error loading notifications: \(error)")
            alertMessage = "Error loading notifications"
            showAlert = true
        }
        isLoading = false
    }
    
    private func fetchLeagueInvites() async throws -> [FantasyLeagueInviteDto] {
        LoggingManager
            .logInfo("Fetching league invites for user \(AuthManager.shared.currentUserId!)")
        
        return try await supabase
            .from("FantasyLeagueInvite")
            .select("*, sender_username:User!FantasyLeagueInvite_sender_id_fkey(username), receiver_username:User!FantasyLeagueInvite_receiver_id_fkey(username), league_name:FantasyLeague!LeagueInvite_league_id_fkey(league_name)")
            .eq("receiver_id", value: AuthManager.shared.currentUserId!)
            .execute()
            .value
    }
    
    public func acceptButtonPressed(senderId: UUID, leagueId: UUID) async {
        LoggingManager
            .logInfo("Accept invitation pressed")
        
        isLoading = true
        do {
            try await updateInvitation(accepted: true, leagueId: leagueId, senderId: senderId)
            removeInvitation(senderId: senderId, leagueId: leagueId)
        } catch {
            LoggingManager
                .logError("Error accepting invitation")
            
            alertMessage = "Error accepting invitation"
            showAlert = true
        }
        isLoading = false
    }
    
    public func declineButtonPressed(senderId: UUID, leagueId: UUID) async {
        LoggingManager
            .logInfo("Decline invitation pressed")
        
        isLoading = true
        do {
            try await updateInvitation(accepted: false, leagueId: leagueId, senderId: senderId)
        } catch {
            LoggingManager
                .logError("Error declining invitation")
            
            alertMessage = "Error declining invitation"
            showAlert = true
        }
        isLoading = false
    }
    
    private func updateInvitation(
        accepted: Bool,
        leagueId: UUID,
        senderId: UUID) async throws {
        LoggingManager
            .logInfo("Updating invitation")
        
        try await supabase
            .from("FantasyLeagueInvite")
            .update(["accepted" : accepted])
            .eq("league_id", value: leagueId)
            .eq("sender_id", value: senderId)
            .eq("receiver_id", value: AuthManager.shared.currentUserId!)
            .execute()
    }
    
    private func removeInvitation(senderId: UUID, leagueId: UUID) {
        allLeagueInvites
            .removeAll { invite in
                invite.leagueId == leagueId &&
                invite.senderId == senderId &&
                invite.receiverId == AuthManager.shared.currentUserId!
            }
    }
}
