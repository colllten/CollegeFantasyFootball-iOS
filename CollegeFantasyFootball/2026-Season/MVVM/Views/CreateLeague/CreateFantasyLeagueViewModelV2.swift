import FactoryKit
import Foundation
import Supabase

@Observable
final class CreateFantasyLeagueViewModelV2: BaseViewModelV2 {
    private var sessionManager = Container.shared.sessionManager()
    private var db = Container.shared.supabaseClient()
    private var auth = Container.shared.authService()
    private var logger = Container.shared.logger()
    
    private let UNIQ_LEAG_NAME_FUNC = "is_fantasy_league_name_unique"
    private let INS_LEAG_FUNC = "insert_fantasy_league"
    
    let MIN_LEAGUE_NAME_LEN = 3
    let MAX_LEAGUE_NAME_LEN = 64
    
    let POS_POINT_RANGE = 0.0...10.0
    let NEG_POINT_RANGE = -10.0...0.0
    
    let MIN_NEG_POINT = -10.0
    let MAX_NEG_POINT = 0.0
    
    let STAT_STEP = 0.5
    
    var newFantasyLeague = FantasyLeagueV2.newLeague
        
    func createFantasyLeague() async {
        logger.logInfo("Attempting to create fantasy league.")
        
        let isValidLeague = await isValidLeague()
        if !isValidLeague { return }
        
        await insertFantasyLeague()
    }
    
    private func isValidLeague() async -> Bool {
        logger.logInfo("Validating fantasy league.")
        
        if !isValidLeagueName() {
            alertMessage = "Invalid league name. Must be \(MIN_LEAGUE_NAME_LEN) in length and not use special characters."
            showAlert = true
            return false
        }
        
        let isLeagueNameUnique = await fetchIsLeagueNameUnique()
        if isLeagueNameUnique == nil {
            alertMessage = "Network error. Please try again soon."
            showAlert = true
            return false
        }
        
        if !isLeagueNameUnique! {
            alertMessage = "Fantasy league name is already taken."
            showAlert = true
            return false
        }
        
        guard let _ = sessionManager.session else {
            logger.logWarning("User session is nil.")
            // TODO: redirect to login instead
            alertMessage = "Error creating fantasy league. Please log out and try again."
            return false
        }
        
        return true
    }
        
    private func isValidLeagueName() -> Bool {
        logger.logInfo("Validating fantasy league name \"\(newFantasyLeague.leagueName)\".")
        
        trimLeagueName()
        
        if !leagueNameMeetsLength() {
            logger.logWarning("Fantasy league name did not meet length requirement (\(MIN_LEAGUE_NAME_LEN)).")
            
            return false
        }
        
        if !validateLeagueNameChars() {
            logger.logWarning("Fantasy league name contains invalid characters.")
            
            return false
        }
        
        return true
    }
    
    private func trimLeagueName() {
        newFantasyLeague.leagueName = newFantasyLeague.leagueName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func validateLeagueNameChars() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[\\w ]+$")
        let range = NSRange(newFantasyLeague.leagueName.startIndex..., in: newFantasyLeague.leagueName)

        return regex.firstMatch(in: newFantasyLeague.leagueName, range: range) != nil
    }
    
    private func leagueNameMeetsLength() -> Bool {
        newFantasyLeague.leagueName.count >= MIN_LEAGUE_NAME_LEN
        &&
        newFantasyLeague.leagueName.count <= MAX_LEAGUE_NAME_LEN
    }
    
    private func fetchIsLeagueNameUnique() async -> Bool? {
        logger.logInfo("Fetching function \(UNIQ_LEAG_NAME_FUNC) result.")
        
        var isUnique = false
        do {
            let response: PostgrestResponse<Bool> = try await db
                .rpc(UNIQ_LEAG_NAME_FUNC,
                     params: [
                        "fantasy_league_name" : newFantasyLeague.leagueName
                     ]).execute()
            isUnique = response.value
        } catch {
            logger.logError("Error fetching result: \(error)")
            return nil
        }
        
        return isUnique
    }
    
    private func insertFantasyLeague() async {
        logger.logInfo("Inserting fantasy league into database.")
        
        guard let userId = sessionManager.session?.user.id else {
            logger.logWarning("User ID is nil.")
            alertMessage = "Error creating league." // TODO: Send back to sign in view
            showAlert = true
            return
        }
        
        let newFantasyLeagueRpcParam = CreateFantasyLeagueFunctionParams(
            newOwnerId: userId,
            newLeagueName: newFantasyLeague.leagueName,
            newCurrentSeason: AppConfig.CURRENT_SEASON, // TODO: Read from config
            newDraftDate: newFantasyLeague.draftDate,
            newPpr: newFantasyLeague.ppr,
            newPointsPer25PassYds: newFantasyLeague.pointsPer25PassYds,
            newPointsPerPassTd: newFantasyLeague.pointsPerPassTd,
            newPointsPerInt: newFantasyLeague.pointsPerInt,
            newPointsPer10RushYds: newFantasyLeague.pointsPer10RushYds,
            newPointsPerRushTd: newFantasyLeague.pointsPerRushTd,
            newPointsPerRec: newFantasyLeague.pointsPerRec,
            newPointsPer10RecYds: newFantasyLeague.pointsPer10RecYds,
            newPointsPerRecTd: newFantasyLeague.pointsPerRecTd,
            newPointsPerFgMade: newFantasyLeague.pointsPerFgMade,
            newPointsPerFgMiss: newFantasyLeague.pointsPerFgMiss,
            newPointsPerXpMade: newFantasyLeague.pointsPerXpMade,
            newPointsPerXpMiss: newFantasyLeague.pointsPerXpMiss,
            newPointsPerPuntIn20: newFantasyLeague.pointsPerPuntIn20,
            newPointsPerKickReturnTd: newFantasyLeague.pointsPerKickReturnTd,
            newPointsPerPuntReturnTd: newFantasyLeague.pointsPerPuntReturnTd,
            newPointsPerFumbleLost: newFantasyLeague.pointsPerFumbleLost,
            newIncludeKickers: newFantasyLeague.includeKickers,
            newIncludePunters: newFantasyLeague.includePunters,
            newIncludeDefense: newFantasyLeague.includeDefense
        )
        
        do {
            try await db.rpc(INS_LEAG_FUNC, params: newFantasyLeagueRpcParam).execute()
        } catch {
            logger.logError("Error fetching result: \(error)")
            alertMessage = "Error creating fantasy league. Please try again soon."
            showAlert = true
            return
        }
        // TODO: Redirect to fantasy league home screen
    }
}
