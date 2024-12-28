////
////  ViewController.swift
////  PakhisAthlinix
////
////  Created by admin65 on 16/12/24.
////
//
//import UIKit
//import Storage
//
//let sessionuser: UUID = UUID(uuidString: "20e33a9c-9e8e-4113-b56a-2a04b96f6b53")!
//
//class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    //var loggedinuser = "2"
//    
//    @IBOutlet weak var backgroundPicture: UIImageView!
//    
//    @IBOutlet weak var profilePicture: UIImageView!
//    
//    @IBOutlet weak var userName: UILabel!
//    @IBOutlet weak var playerOrCoachLabel: UILabel!
//    @IBOutlet weak var userBio: UILabel!
//    @IBOutlet weak var position: UILabel!
//    @IBOutlet weak var matches: UILabel!
//    @IBOutlet weak var height: UILabel!
//    @IBOutlet weak var weight: UILabel!
//    @IBOutlet weak var ppg: UILabel!
//    @IBOutlet weak var bpg: UILabel!
//    @IBOutlet weak var ast: UILabel!
//    
//    @IBOutlet weak var teamCollectionView: UICollectionView!
//    @IBOutlet weak var tableView: UITableView!
//    
//    
//    @IBOutlet weak var bestGameMyTeamLogo: UIImageView!
//    @IBOutlet weak var bestGameMyTeamName: UILabel!
//    @IBOutlet weak var bestGameOpponentTeamLogo: UIImageView!
//    @IBOutlet weak var bestGameOpponentTeamName: UILabel!
//    @IBOutlet weak var bestGameMyTeam2pters: UILabel!
//    @IBOutlet weak var bestGameMyTeam3pters: UILabel!
//    @IBOutlet weak var bestGameMyTeamFreeThrows: UILabel!
//    @IBOutlet weak var bestGameOpponentTeam2pters: UILabel!
//    @IBOutlet weak var bestGameOpponentTeam3pters: UILabel!
//    @IBOutlet weak var bestGameOpponentFreeThrows: UILabel!
//    
//    var user: User?
//    var athleteProfile: AthleteProfile?
//    var teams1: [Teams] = []
//    var posts1: [Post] = []
//    var bestGame: Game?
//    var gameLogs1: [GameLog] = []
//    
//    //MARK: supabase declarations
//    var user11: Usertable?
//    var teams11:[TeamTable] = []
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Fetch primary data
//       // setupPrimaryData(forUserID: loggedInUserID) // Example: Fetch data for userID "1"
//        
//        // Set up UI
//        //setupProfileDetails()
//        //fetchTeams()
//        
//        fetchTeamsForUserSupabase(userID: sessionuser)
//        
//        Task{
//            await setupPrimaryDataSupabase(forUserID: sessionuser)
//            await setupProfileDetailsSupabase()
//            
//            if let bestMatch = await fetchBestMatchSupabase(forPlayerID: sessionuser) {
//                await updateBestGameViewSupabase(with: bestMatch)
//            }
//            await displayBestGameSupabase()
//        }
//        
//        fetchPosts()
//        
//        //fetchBestMatchSupabase(forPlayerID: sessionuser)
//        
//       
//        // Set delegates and data sources
//        teamCollectionView.delegate = self
//        teamCollectionView.dataSource = self
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//    
//    // MARK: - Fetch Data from Supabase
//    func setupPrimaryDataSupabase(forUserID userID: UUID) async {
//        do {
//            // Fetch User data
//            let userResponse = try await supabase.from("User").select("*").eq("userID", value: userID).single().execute()
//            let userDecoder = JSONDecoder()
//            let matchedUser = try userDecoder.decode(Usertable.self, from: userResponse.data)
//            user11 = matchedUser
//            
//            // Fetch Athlete Profile data (if applicable)
//            if user11?.role == .athlete {
//                let athleteResponse = try await supabase.from("AthleteProfile").select("*").eq("athleteID", value: userID).single().execute()
//                let athleteDecoder = JSONDecoder()
//                let matchedAthleteProfile = try athleteDecoder.decode(AthleteProfile.self, from: athleteResponse.data)
//                athleteProfile = matchedAthleteProfile
//            }
//        } catch {
//            print("Error setting up primary data: \(error)")
//        }
//    }
//    /// MARK: - Fetch and Assign Primary Data
////    func setupPrimaryData(forUserID userID: String) {
////        // Find user with matching userID
////        if let matchedUser = users.first(where: { $0.userID == userID }) {
////            user = matchedUser
////        }
////        
////        // Find athlete profile with matching athleteID
////        if let matchedAthleteProfile = athleteProfiles.first(where: { $0.athleteID == userID }) {
////            athleteProfile = matchedAthleteProfile
////        }
////    }
//    
//    // MARK: - Calculate Games Played Supabase
//    func calculateGamesPlayedsupabase(forUserID userID: UUID) async -> Int {
//        do {
//            // Fetch game logs for the user
//            let logsResponse = try await supabase.from("GameLog").select("*").eq("playerID", value: userID).execute()
//            let logsDecoder = JSONDecoder()
//            let gameLogs = try logsDecoder.decode([GameLogtable].self, from: logsResponse.data)
//            
//            // Extract unique game IDs
//            let matchesPlayed = Set(gameLogs.map { $0.gameID }).count
//            print("calculated games = \(matchesPlayed)")
//            return matchesPlayed
//        } catch {
//            print("Error calculating games played: \(error)")
//            return 0
//        }
//    }
//
//    /// MARK: - Calculate Games Played
////    func calculateGamesPlayed(forUserID userID: String) -> Int {
////        // Extract unique game IDs
////        let matchesPlayed = Set(gameLogs.filter { $0.playerID == loggedInUserID }.map { $0.gameID }).count
////        // Return the count of unique games
////        return matchesPlayed
////    }
//    
//    
//    // MARK: - Setup Profile Details Supabase
//    func setupProfileDetailsSupabase() async {
//        guard let user11 = user11 else {
//            print("User data is missing")
//            return
//        }
//        
//        // Set user profile details
//        userName.text = user11.name
//        playerOrCoachLabel.text = user11.role == .athlete ? "Athlete" : "Coach"
//        userBio.text = user11.bio
//        profilePicture.image = UIImage(named: user11.profilePicture ?? "")
//        backgroundPicture.image = UIImage(named: user11.coverPicture ?? "")
//        
//        // Set athlete-specific details if the user is an athlete
//        if user11.role == .athlete, let athleteProfile = athleteProfile {
//            position.text = athleteProfile.position
//            height.text = "\(athleteProfile.height) cm"
//            weight.text = "\(athleteProfile.weight) kg"
//            ppg.text = "\(athleteProfile.averagePointsPerGame)"
//            bpg.text = "\(athleteProfile.averageReboundsPerGame)"
//            ast.text = "\(athleteProfile.averageAssistsPerGame)"
//            
//            // Calculate and display the number of games played
//            let matchesPlayed = await calculateGamesPlayedsupabase(forUserID: sessionuser)
//            matches.text = "\(matchesPlayed)"
//        } else {
//            // Hide athlete-specific labels for coaches
//            position.isHidden = true
//            height.isHidden = true
//            weight.isHidden = true
//            ppg.isHidden = true
//            bpg.isHidden = true
//            ast.isHidden = true
//        }
//    }
//    
//    /// MARK: - Setup Profile Details
////    func setupProfileDetails() {
////        guard let user = user else {
////            print("User data is missing")
////            return
////        }
////        
////        
////        // Set user profile details
////        userName.text = user.name
////        playerOrCoachLabel.text = user.role == .athlete ? "Athlete" : "Coach"
////        userBio.text = user.bio
////        profilePicture.image = UIImage(named: user.profilePicture)
////        backgroundPicture.image = UIImage(named: user.coverPicture ?? "")
////        
////        // Set athlete-specific details if the user is an athlete
////        if user.role == .athlete, let athleteProfile = athleteProfile {
////            position.text = athleteProfile.position
////            height.text = "\(athleteProfile.height) cm"
////            weight.text = "\(athleteProfile.weight) kg"
////            ppg.text = "\(athleteProfile.averagePointsPerGame)"
////            bpg.text = "\(athleteProfile.averageReboundsPerGame)"
////            ast.text = "\(athleteProfile.averageAssistsPerGame)"
////            
////            // Calculate and display the number of games played
////            print("Logged-in User ID: \(loggedInUserID)")
////            print("Game Logs: \(gameLogs)")
////            
////            // Calculate and display matches played
////            let matchesPlayed = Set(gameLogs.filter { $0.playerID == loggedInUserID }.map { $0.gameID }).count
////            print("Matches Played: \(matchesPlayed)") // Debugging
////            
////            matches.text = "\(matchesPlayed)"
////        } else {
////            // Hide athlete-specific labels for coaches
////            position.isHidden = true
////            height.isHidden = true
////            weight.isHidden = true
////            ppg.isHidden = true
////            bpg.isHidden = true
////            ast.isHidden = true
////        }
////    }
//    
    // MARK: - Fetch Best Match
//    func fetchBestMatch(forPlayerID playerID: String) -> Game? {
//        // Filter games where the player participated
//        let playerGameLogs = gameLogs.filter { $0.playerID == playerID }
//        let playerGameIDs = Set(playerGameLogs.map { $0.gameID })
//        let playerGames = games.filter { playerGameIDs.contains($0.gameID) }
//        
//        // Select the best match (e.g., highest total points scored by the player's team)
//        var bestGame: Game?
//        var maxPoints = 0
//        
//        for game in playerGames {
//            let teamLogs = playerGameLogs.filter { $0.gameID == game.gameID }
//            let teamPoints = teamLogs.reduce(0) { $0 + $1.totalPoints }
//            
//            if teamPoints > maxPoints {
//                maxPoints = teamPoints
//                bestGame = game
//            }
//        }
//        
//        return bestGame
//    }
//    
//    // MARK: - Fetch Best Match Supabase
//    func fetchBestMatchSupabase(forPlayerID playerID: UUID) async -> GameTable? {
//        do {
//            // Fetch game logs for the player
//            let gameLogResponse = try await supabase
//                .from("GameLog")
//                .select("*")
//                .eq("playerID", value: playerID.uuidString)
//                .execute()
//            let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogResponse.data)
//            
//            // Extract game IDs
//            let playerGameIDs = Set(gameLogs.map { $0.gameID })
//            
//            // Fetch games
//            let gamesResponse = try await supabase
//                .from("Game")
//                .select("*").in("gameID", values: Array(playerGameIDs.map{$0.uuidString})).execute()
//            
//            let games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)
//            
//            // Find the best match (highest total points)
//            var bestGame: GameTable?
//            var maxPoints = 0
//            
//            for game in games {
//                let teamLogs = gameLogs.filter { $0.gameID == game.gameID }
//                let teamPoints = teamLogs.reduce(0) { $0 + $1.totalPoints }
//                
//                if teamPoints > maxPoints {
//                    maxPoints = teamPoints
//                    bestGame = game
//                }
//            }
//            
//            return bestGame
//        } catch {
//            print("Error fetching best match: \(error)")
//            return nil
//        }
//    }
//    
//    
////    // MARK: - Update UI of pinned matches
////    func updateBestGameView(with game: Game) {
////        // Fetch team details
////        guard let team1 = teams.first(where: { $0.teamID == game.team1ID }),
////              let team2 = teams.first(where: { $0.teamID == game.team2ID }) else { return }
////        
////        // Update labels
////        bestGameMyTeamName.text = team1.teamName
////        bestGameOpponentTeamName.text = team2.teamName
////        
////        // Update images (use a placeholder or a utility for image loading)
////        bestGameMyTeamLogo.image = UIImage(named: team1.teamLogo)
////        bestGameOpponentTeamLogo.image = UIImage(named: team2.teamLogo)
////        
////        // Fetch game logs for the match
////        let team1Logs = gameLogs.filter { $0.gameID == game.gameID && $0.teamID == game.team1ID }
////        let team2Logs = gameLogs.filter { $0.gameID == game.gameID && $0.teamID == game.team2ID }
////        
////        // Calculate stats
////        bestGameMyTeam2pters.text = "\(team1Logs.reduce(0) { $0 + $1.points2 })"
////        bestGameMyTeam3pters.text = "\(team1Logs.reduce(0) { $0 + $1.points3 })"
////        bestGameMyTeamFreeThrows.text = "\(team1Logs.reduce(0) { $0 + $1.freeThrows })"
////        
////        bestGameOpponentTeam2pters.text = "\(team2Logs.reduce(0) { $0 + $1.points2 })"
////        bestGameOpponentTeam3pters.text = "\(team2Logs.reduce(0) { $0 + $1.points3 })"
////        bestGameOpponentFreeThrows.text = "\(team2Logs.reduce(0) { $0 + $1.freeThrows })"
////    }
////    
//    // MARK: - Update UI of pinned matches Supabase
//    func updateBestGameViewSupabase(with game: GameTable) async {
//        do {
//            // Fetch team details
//            let team1Response = try await supabase
//                .from("teams")
//                .select("*")
//                .eq("teamID", value: game.team1ID.uuidString)
//                .execute()
//            let team2Response = try await supabase
//                .from("teams")
//                .select("*")
//                .eq("teamID", value: game.team2ID.uuidString)
//                .execute()
//            
//            let team1 = try JSONDecoder().decode(TeamTable.self, from: team1Response.data)
//            let team2 = try JSONDecoder().decode(TeamTable.self, from: team2Response.data)
//            
//            // Update labels
//            DispatchQueue.main.async {
//                self.bestGameMyTeamName.text = team1.teamName
//                self.bestGameOpponentTeamName.text = team2.teamName
//                
//                // Update images (use a placeholder or utility for image loading)
//                self.bestGameMyTeamLogo.image = UIImage(named: team1.teamLogo ?? "placeholder")
//                self.bestGameOpponentTeamLogo.image = UIImage(named: team2.teamLogo ?? "placeholder")
//            }
//            
//            // Fetch game logs for the match
//            let logsResponse = try await supabase
//                .from("GameLog")
//                .select("*")
//                .eq("gameID", value: game.gameID.uuidString)
//                .execute()
//            let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: logsResponse.data)
//            
//            let team1Logs = gameLogs.filter { $0.teamID == game.team1ID }
//            let team2Logs = gameLogs.filter { $0.teamID == game.team2ID }
//            
//            // Calculate stats
//            DispatchQueue.main.async {
//                self.bestGameMyTeam2pters.text = "\(team1Logs.reduce(0) { $0 + $1.points2 })"
//                self.bestGameMyTeam3pters.text = "\(team1Logs.reduce(0) { $0 + $1.points3 })"
//                self.bestGameMyTeamFreeThrows.text = "\(team1Logs.reduce(0) { $0 + $1.freeThrows })"
//                
//                self.bestGameOpponentTeam2pters.text = "\(team2Logs.reduce(0) { $0 + $1.points2 })"
//                self.bestGameOpponentTeam3pters.text = "\(team2Logs.reduce(0) { $0 + $1.points3 })"
//                self.bestGameOpponentFreeThrows.text = "\(team2Logs.reduce(0) { $0 + $1.freeThrows })"
//            }
//        } catch {
//            print("Error updating best game view: \(error)")
//        }
//    }
//    // MARK: - Display Best Game Supabase
//    func displayBestGameSupabase() async {
//        do {
//            // Fetch game logs for the current user
//            guard let userID = user11?.userID else { return }
//            let logsResponse = try await supabase
//                .from("GameLog")
//                .select("*")
//                .eq("playerID", value: userID.uuidString)
//                .execute()
//            let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: logsResponse.data)
//            
//            // Find the best game log
//            guard let bestLog = gameLogs.max(by: { $0.totalPoints < $1.totalPoints }) else { return }
//            
//            // Fetch game
//            let gameResponse = try await supabase
//                .from("Game")
//                .select("*")
//                .eq("gameID", value: bestLog.gameID.uuidString)
//                .execute()
//            let bestGame = try JSONDecoder().decode(GameTable.self, from: gameResponse.data)
//            
//            // Fetch team details
//            let myTeamResponse = try await supabase
//                .from("teams")
//                .select("*")
//                .eq("teamID", value: bestLog.teamID.uuidString)
//                .execute()
//            let opponentTeamResponse = try await supabase
//                .from("teams")
//                .select("*")
//                .or("teamID.eq.\(bestGame.team1ID.uuidString),teamID.eq.\(bestGame.team2ID.uuidString)")
//                .neq("teamID", value: bestLog.teamID.uuidString)
//                .execute()
//            
//            let myTeam = try JSONDecoder().decode(TeamTable.self, from: myTeamResponse.data)
//            let opponentTeam = try JSONDecoder().decode(TeamTable.self, from: opponentTeamResponse.data)
//            
//            // Update UI
//            DispatchQueue.main.async {
//                self.bestGameMyTeamName.text = myTeam.teamName
//                self.bestGameMyTeamLogo.image = UIImage(named: myTeam.teamLogo ?? "placeholder")
//                self.bestGameOpponentTeamName.text = opponentTeam.teamName
//                self.bestGameOpponentTeamLogo.image = UIImage(named: opponentTeam.teamLogo ?? "placeholder")
//                self.bestGameMyTeam2pters.text = "\(bestLog.points2)"
//                self.bestGameMyTeam3pters.text = "\(bestLog.points3)"
//                self.bestGameMyTeamFreeThrows.text = "\(bestLog.freeThrows)"
//            }
//        } catch {
//            print("Error displaying best game: \(error)")
//        }
//    }
//    
////    // MARK: - Display Best Game
////    func displayBestGame() {
////        // Example logic to find the best game based on total points
////        let bestGameLog = gameLogs.filter { $0.playerID == user?.userID }.max { $0.totalPoints < $1.totalPoints }
////        guard let bestLog = bestGameLog else { return }
////        bestGame = games.first { $0.gameID == bestLog.gameID }
////        
////        // Populate UI with best game data
////        guard let game = bestGame else { return }
////        let myTeam = teams.first { $0.teamID == bestLog.teamID }
////        let opponentTeam = teams.first { $0.teamID != bestLog.teamID && ($0.teamID == game.team1ID || $0.teamID == game.team2ID) }
////        
////        bestGameMyTeamName.text = myTeam?.teamName
////        bestGameMyTeamLogo.image = UIImage(named: myTeam?.teamLogo ?? "")
////        bestGameOpponentTeamName.text = opponentTeam?.teamName
////        bestGameOpponentTeamLogo.image = UIImage(named: opponentTeam?.teamLogo ?? "")
////        bestGameMyTeam2pters.text = "\(bestLog.points2)"
////        bestGameMyTeam3pters.text = "\(bestLog.points3)"
////        bestGameMyTeamFreeThrows.text = "\(bestLog.freeThrows)"
////    }
//
//    // MARK: - Fetch Teams Supabase
////    func fetchTeams() {
////        // Filter memberships for the current user and fetch their teams
////        let memberships = teamMemberships.filter { $0.userID == user?.userID }
////        teams1 = memberships.compactMap { membership in
////            teams.first { $0.teamID == membership.teamID }
////        }
////        teamCollectionView.reloadData()
////    }
//    func fetchTeamsForUserSupabase(userID: UUID?) {
//        guard let userID = userID else {
//            print("User ID is nil")
//            return
//        }
//        
//        Task {
//            do {
//                // Fetch memberships for the current user
//                let membershipsResponse = try await supabase
//                    .from("teamMembership")
//                    .select("*")
//                    .eq("userID", value: userID.uuidString)
//                    .execute()
//                
//                let decoder = JSONDecoder()
//                let memberships = try decoder.decode([TeamMembershipTable].self, from: membershipsResponse.data)
//                
//                // Extract teamIDs from memberships
//                let teamIDs = memberships.map { $0.teamID.uuidString }
//                
//                // Fetch teams matching the teamIDs
//                let teamsResponse = try await supabase
//                    .from("teams")
//                    .select("*")
//                    .in("teamID", values: teamIDs)
//                    .execute()
//                
//                let teams2 = try decoder.decode([TeamTable].self, from: teamsResponse.data)
//                
//                print("Teams for user: \(teams2)")
//                
//                // Handle the fetched teams (update UI, etc.)
//                teams11 = teams2
//                teamCollectionView.reloadData()
//            } catch {
//                print("Error fetching teams: \(error)")
//            }
//        }
//    }
//    
//    // MARK: - Fetch Posts
//    func fetchPosts() {
//        posts1 = posts.filter { $0.createdBy == loggedInUserID }
//        tableView.reloadData()
//    }
//    
//
//    
//    // MARK: FEED
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts1.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostCell", for: indexPath) as? ProfilePostCell else {
//            return UITableViewCell()
//        }
//        
//        // Fetch the post from the filtered posts array
//        let post = posts1[indexPath.row]
//        
//        // Configure cell with the post data
//        if let user = users.first(where: { $0.userID == post.createdBy }) {
//            cell.athleteNameLabel.text = user.name
//            cell.profileImageView.image = UIImage(named: user.profilePicture.isEmpty ? "defaultProfile" : user.profilePicture)
//        } else {
//            cell.athleteNameLabel.text = " "
//            cell.profileImageView.image = UIImage(named: "defaultProfile")
//        }
//        
//        if let linkedGameID = post.linkedGameID,
//           let game = games.first(where: { $0.gameID == linkedGameID }),
//           let team = teams.first(where: { $0.teamID == game.team1ID }) {
//            cell.teamNameLabel.text = team.teamName
//            cell.teamLogoImageView.image = UIImage(named: team.teamLogo.isEmpty ? "defaultTeamLogo" : team.teamLogo)
//        } else {
//            cell.teamNameLabel.text = "Unknown Team"
//            cell.teamLogoImageView.image = UIImage(named: "defaultTeamLogo")
//        }
//        
//        cell.imageView1.image = UIImage(named: post.image1)
//        cell.imageView2.image = UIImage(named: post.image2)
//        cell.imageView3.image = UIImage(named: post.image3)
//        
//        return cell
//    }
//}
//// MARK: - UICollectionView
//extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return teams11.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCollectionViewCell
//        cell.configure(with: teams11[indexPath.row])
//        return cell
//    }
//}
//
//// MARK: - UITableView
////extension ViewController: UITableViewDelegate, UITableViewDataSource {
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return posts.count
////    }
////    
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
////        cell.configure(with: posts[indexPath.row])
////        return cell
////    }
////}
