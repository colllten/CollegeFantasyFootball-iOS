//
//  InviteUserViewModel.swift
//  CollegeFantasyFootball
//
//  Created by Colten Glover on 7/14/25.
//

import Foundation
import PostgREST

class InviteUserViewModel: BaseViewModel {
    @Published var fantasyLeagueInvites = [Invite]()
    var inviteeIds: [UUID] {
        fantasyLeagueInvites.map { invite in
            invite.receiverId
        }
    }
    
    var fantasyLeague: FantasyLeague
//    let userId = UserDefaults.standard.string(forKey: "userId")
    
    @Published var searchText = ""
    @Published var users = [UsernameQueryResponse]()
    
    
    var usernames: [UsernameQueryResponse] {
        users
            .filter { user in
                user.id != AuthManager.shared.currentUserId!
                &&
                !inviteeIds.contains(user.id)
            }
    }
    
    init(fantasyLeague: FantasyLeague) {
        self.fantasyLeague = fantasyLeague
    }
    
    public func loadData() async {
        isLoading = true
        do {
            fantasyLeagueInvites = try await fetchFantasyLeagueInvites()
        } catch {
            let errorMsg = "Error fetching fantasy league invites"
            LoggingManager
                .logError(errorMsg + "\(error)")
            
            alertMessage = errorMsg
            showAlert = true
        }
        isLoading = false
    }
    
    private func fetchFantasyLeagueInvites() async throws -> [Invite] {
        LoggingManager
            .logInfo("Fetching invites for fantasy league \(fantasyLeague.id)")
        
        // TODO: League name, Sender username not needed, but don't want duplicate Dtos
        return try await supabase
            .from("FantasyLeagueInvite")
            .select("*, receiver_username:User!FantasyLeagueInvite_receiver_id_fkey(username)")
            .eq("league_id", value: fantasyLeague.id)
            .execute()
            .value
    }
        
    public func trySearchUsername() async {
        LoggingManager
            .logInfo("Searching for username \"\(searchText)\"")
        
        isLoading = true
        do {
            searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            users = try await searchForUsername()
        } catch {
            LoggingManager
                .logError("Error searching for username: \(error)")
            
            alertMessage = "Error searching for username"
            showAlert = true
        }
        isLoading = false
    }
    
    public func inviteButtonPressed(id: UUID) async {
        LoggingManager
            .logInfo("Invite button pressed")
        
        isLoading = true
        do {
            try await inviteUserToLeague(id: id)
            addToInvitedList(id: id)
        } catch {
            let errorMessage = "Error sending invite"
            LoggingManager
                .logError(errorMessage + "\(error)")
            
            alertMessage = errorMessage
            showAlert = true
        }
        isLoading = false
    }
    
    private func inviteUserToLeague(id: UUID) async throws {
        let invite = FantasyLeagueInvite(
            leagueId: fantasyLeague.id,
            receiverId: id,
            senderId: AuthManager.shared.currentUserId!,
            accepted: nil)
        
        try await supabase
            .from("FantasyLeagueInvite")
            .insert(invite)
            .execute()
    }
    
    private func searchForUsername() async throws -> [UsernameQueryResponse] {
        let data: PostgrestResponse<[UsernameQueryResponse]> = try await supabase
            .from("User")
            .select("id, username")
            .ilike("username", pattern: "%\(searchText)%")
            .limit(20)
            .execute()
        
        return data.value
    }
    
    private func addToInvitedList(id: UUID) {
        LoggingManager
            .logInfo("Adding \(id) to invite list")
        
        let receiverUsername = usernames.first { user in
            user.id == id
        }?.username
        
        let invite = Invite(
            leagueId: fantasyLeague.id,
            receiverId: id,
            accepted: nil,
            receiverUsername: Invite.ReceiverUsername(username: receiverUsername ?? "")
        )
        
        fantasyLeagueInvites.append(invite)
    }
    
    enum InviteError: Error {
        case UsernameNotFound
    }
}

struct UsernameQueryResponse: Codable {
    let id: UUID
    let username: String
}

struct Invite: Identifiable, Codable {
    let id = UUID()
    let leagueId: UUID
    let receiverId: UUID
    let accepted: Bool?
    let receiverUsername: ReceiverUsername
    
    enum CodingKeys: String, CodingKey {
        case leagueId = "league_id"
        case receiverId = "receiver_id"
        case accepted = "accepted"
        case receiverUsername = "receiver_username"
    }
    
    struct ReceiverUsername: Codable {
        let username: String
    }
}

