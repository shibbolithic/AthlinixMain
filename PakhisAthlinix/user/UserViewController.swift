//
//  ViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 16/12/24.
//

import UIKit
import Storage

let sessionuser: UUID = UUID(uuidString: "20e33a9c-9e8e-4113-b56a-2a04b96f6b53")!

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //var loggedinuser = "2"
    
    @IBOutlet weak var backgroundPicture: UIImageView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var playerOrCoachLabel: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var matches: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var ppg: UILabel!
    @IBOutlet weak var bpg: UILabel!
    @IBOutlet weak var ast: UILabel!
    
    @IBOutlet weak var teamCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var bestGameMyTeamLogo: UIImageView!
    @IBOutlet weak var bestGameMyTeamName: UILabel!
    @IBOutlet weak var bestGameOpponentTeamLogo: UIImageView!
    @IBOutlet weak var bestGameOpponentTeamName: UILabel!
    @IBOutlet weak var bestGameMyTeam2pters: UILabel!
    @IBOutlet weak var bestGameMyTeam3pters: UILabel!
    @IBOutlet weak var bestGameMyTeamFreeThrows: UILabel!
    @IBOutlet weak var bestGameOpponentTeam2pters: UILabel!
    @IBOutlet weak var bestGameOpponentTeam3pters: UILabel!
    @IBOutlet weak var bestGameOpponentFreeThrows: UILabel!
    
    var user: User?
    var athleteProfile: AthleteProfile?
    var teams1: [Teams] = []
    var bestGame: Game?
    var gameLogs1: [GameLog] = []
    var posts1: [Post] = []
    
    
    //MARK: supabase declarations
    var user11: Usertable?
    var teams11:[TeamTable] = []
    var posts11: [PostsTable] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTeamsForUserSupabase(userID: sessionuser)
        
        Task{
            do{
                await setupPrimaryDataSupabase(forUserID: sessionuser)
                await setupProfileDetailsSupabase()
                
                await fetchPosts()
                
                if let bestMatch = try await fetchBestMatchSupabase(forPlayerID: sessionuser) {
                    await updateBestGameViewSupabase(with: bestMatch)
                }
                await displayBestGameSupabase()
            } catch {
                // Handle the error gracefully
                print("Error fetching best match: \(error)")
            }
        }
        //fetchBestMatchSupabase(forPlayerID: sessionuser)
        // Set delegates and data sources
        teamCollectionView.delegate = self
        teamCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Fetch Data from Supabase
    func setupPrimaryDataSupabase(forUserID userID: UUID) async {
        do {
            // Fetch User data
            let userResponse = try await supabase.from("User").select("*").eq("userID", value: userID).single().execute()
            let userDecoder = JSONDecoder()
            let matchedUser = try userDecoder.decode(Usertable.self, from: userResponse.data)
            user11 = matchedUser
            
            // Fetch Athlete Profile data (if applicable)
            if user11?.role == .athlete {
                let athleteResponse = try await supabase.from("AthleteProfile").select("*").eq("athleteID", value: userID).single().execute()
                let athleteDecoder = JSONDecoder()
                let matchedAthleteProfile = try athleteDecoder.decode(AthleteProfile.self, from: athleteResponse.data)
                athleteProfile = matchedAthleteProfile
            }
        } catch {
            print("Error setting up primary data: \(error)")
        }
    }
    /// MARK: - Fetch and Assign Primary Data
    //    func setupPrimaryData(forUserID userID: String) {
    //        // Find user with matching userID
    //        if let matchedUser = users.first(where: { $0.userID == userID }) {
    //            user = matchedUser
    //        }
    //
    //        // Find athlete profile with matching athleteID
    //        if let matchedAthleteProfile = athleteProfiles.first(where: { $0.athleteID == userID }) {
    //            athleteProfile = matchedAthleteProfile
    //        }
    //    }
    
    // MARK: - Calculate Games Played Supabase
    func calculateGamesPlayedsupabase(forUserID userID: UUID) async -> Int {
        do {
            // Fetch game logs for the user
            let logsResponse = try await supabase.from("GameLog").select("*").eq("playerID", value: userID).execute()
            let logsDecoder = JSONDecoder()
            let gameLogs = try logsDecoder.decode([GameLogtable].self, from: logsResponse.data)
            
            // Extract unique game IDs
            let matchesPlayed = Set(gameLogs.map { $0.gameID }).count
            print("calculated games = \(matchesPlayed)")
            return matchesPlayed
        } catch {
            print("Error calculating games played: \(error)")
            return 0
        }
    }
    
    /// MARK: - Calculate Games Played
    //    func calculateGamesPlayed(forUserID userID: String) -> Int {
    //        // Extract unique game IDs
    //        let matchesPlayed = Set(gameLogs.filter { $0.playerID == loggedInUserID }.map { $0.gameID }).count
    //        // Return the count of unique games
    //        return matchesPlayed
    //    }
    
    
    // MARK: - Setup Profile Details Supabase
    func setupProfileDetailsSupabase() async {
        guard let user11 = user11 else {
            print("User data is missing")
            return
        }
        
        // Set user profile details
        userName.text = user11.name
        playerOrCoachLabel.text = user11.role == .athlete ? "Athlete" : "Coach"
        userBio.text = user11.bio
        profilePicture.image = UIImage(named: user11.profilePicture ?? "")
        backgroundPicture.image = UIImage(named: user11.coverPicture ?? "")
        
        // Set athlete-specific details if the user is an athlete
        if user11.role == .athlete, let athleteProfile = athleteProfile {
            position.text = athleteProfile.position
            height.text = "\(athleteProfile.height) cm"
            weight.text = "\(athleteProfile.weight) kg"
            ppg.text = "\(athleteProfile.averagePointsPerGame)"
            bpg.text = "\(athleteProfile.averageReboundsPerGame)"
            ast.text = "\(athleteProfile.averageAssistsPerGame)"
            
            // Calculate and display the number of games played
            let matchesPlayed = await calculateGamesPlayedsupabase(forUserID: sessionuser)
            matches.text = "\(matchesPlayed)"
        } else {
            // Hide athlete-specific labels for coaches
            position.isHidden = true
            height.isHidden = true
            weight.isHidden = true
            ppg.isHidden = true
            bpg.isHidden = true
            ast.isHidden = true
        }
    }
    
    // MARK: - Fetch Best Match Supabase
    func fetchBestMatch(forPlayerID playerID: String) -> Game? {
        // Filter games where the player participated
        let playerGameLogs = gameLogs.filter { $0.playerID == playerID }
        let playerGameIDs = Set(playerGameLogs.map { $0.gameID })
        let playerGames = games.filter { playerGameIDs.contains($0.gameID) }
        
        // Select the best match (e.g., highest total points scored by the player's team)
        var bestGame: Game?
        var maxPoints = 0
        
        for game in playerGames {
            let teamLogs = playerGameLogs.filter { $0.gameID == game.gameID }
            let teamPoints = teamLogs.reduce(0) { $0 + $1.totalPoints }
            
            if teamPoints > maxPoints {
                maxPoints = teamPoints
                bestGame = game
            }
        }
        
        return bestGame
    }
    // MARK: NEW FETCH MATCHES
    func fetchBestMatchSupabase(forPlayerID playerID: UUID) async throws -> GameTable? {
        // Step 1: Fetch GameLogs for the player
        let gameLogsResponse = try await supabase
            .from("GameLog")
            .select("*")
            .eq("playerID", value: playerID)
            .execute()
        //print(gameLogsResponse)
        // Decode GameLogs
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Adjust if your dates use a different format
        let gameLogsData = gameLogsResponse.data // No need for conditional binding
        
        // print(gameLogsData)
        
        let playerGameLogs = try decoder.decode([GameLogtable].self, from: gameLogsData)
        
        //print(playerGameLogs) // gives data in bytes
        
        // Extract game IDs
        let playerGameIDs = playerGameLogs.map { $0.gameID }
        
        //print(playerGameIDs)
        
        // Step 2: Fetch Games for the extracted game IDs
        let gamesResponse = try await supabase
            .from("Game")
            .select("*").in("gameID", values: playerGameIDs)
            .execute()
        //print(gamesResponse)
        // Decode Games
        let gamesData = gamesResponse.data // No need for conditional binding
        
        //print(gamesData)
        
        let playerGames = try decoder.decode([GameTable].self, from: gamesData)
        
        print(playerGames)
        // Step 3: Find the best game based on the highest total points scored
        
        var bestGame: GameTable?
        
        var maxPoints = 0
        
        for game in playerGames {
            let teamLogs = playerGameLogs.filter { $0.gameID == game.gameID }
            print(teamLogs)
            print("sup")
            let teamPoints = teamLogs.reduce(0) { $0 + $1.totalPoints }
            
            print(teamPoints)
            
            if teamPoints > maxPoints {
                maxPoints = teamPoints
                print(maxPoints)
                bestGame = game
                print(bestGame)
            }
        }
        return bestGame
    }
    
    // MARK: - Update UI of pinned matches Supabase
    func updateBestGameViewSupabase(with game: GameTable) async {
        do {
            // Fetch team details
            let team1Response = try await supabase
                .from("teams")
                .select("*")
                .eq("teamID", value: game.team1ID.uuidString).single()
                .execute()
            
            print("yo  wad,mnssup")
            print(team1Response.data)
            
            let team2Response = try await supabase
                .from("teams")
                .select("*")
                .eq("teamID", value: game.team2ID.uuidString).single()
                .execute()
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let team1 = try decoder.decode(TeamTable.self, from: team1Response.data)
            
            //print(team1)
            let team2 = try decoder.decode(TeamTable.self, from: team2Response.data)
            
            print("yo  wassup")
            print(team1)
            print(team2)
            
            // Update labels
            DispatchQueue.main.async {
                self.bestGameMyTeamName.text = team1.teamName
                self.bestGameOpponentTeamName.text = team2.teamName
                
                // Update images (use a placeholder or utility for image loading)
                self.bestGameMyTeamLogo.image = UIImage(named: team1.teamLogo ?? "placeholder")
                self.bestGameOpponentTeamLogo.image = UIImage(named: team2.teamLogo ?? "placeholder")
            }
            
            // Fetch game logs for the match
            let logsResponse = try await supabase
                .from("GameLog")
                .select("*")
                .eq("gameID", value: game.gameID.uuidString)
                .execute()
            let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: logsResponse.data)
            
            let team1Logs = gameLogs.filter { $0.teamID == game.team1ID }
            let team2Logs = gameLogs.filter { $0.teamID == game.team2ID }
            
            // Calculate stats
            DispatchQueue.main.async {
                self.bestGameMyTeam2pters.text = "\(team1Logs.reduce(0) { $0 + $1.points2 })"
                self.bestGameMyTeam3pters.text = "\(team1Logs.reduce(0) { $0 + $1.points3 })"
                self.bestGameMyTeamFreeThrows.text = "\(team1Logs.reduce(0) { $0 + $1.freeThrows })"
                
                self.bestGameOpponentTeam2pters.text = "\(team2Logs.reduce(0) { $0 + $1.points2 })"
                self.bestGameOpponentTeam3pters.text = "\(team2Logs.reduce(0) { $0 + $1.points3 })"
                self.bestGameOpponentFreeThrows.text = "\(team2Logs.reduce(0) { $0 + $1.freeThrows })"
            }
        } catch {
            print("Error updating best game view: \(error)")
        }
    }
    // MARK: - Display Best Game Supabase
    func displayBestGameSupabase() async {
        do {
            // Fetch game logs for the current user
            guard let userID = user11?.userID else { return }
            let logsResponse = try await supabase
                .from("GameLog")
                .select("*")
                .eq("playerID", value: userID.uuidString)
                .execute()
            let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: logsResponse.data)
            
            // Find the best game log
            guard let bestLog = gameLogs.max(by: { $0.totalPoints < $1.totalPoints }) else { return }
            
            // Fetch game
            let gameResponse = try await supabase
                .from("Game")
                .select("*")
                .eq("gameID", value: bestLog.gameID.uuidString)
                .execute()
            let bestGame = try JSONDecoder().decode(GameTable.self, from: gameResponse.data)
            
            // Fetch team details
            let myTeamResponse = try await supabase
                .from("teams")
                .select("*")
                .eq("teamID", value: bestLog.teamID.uuidString)
                .execute()
            let opponentTeamResponse = try await supabase
                .from("teams")
                .select("*")
                .or("teamID.eq.\(bestGame.team1ID.uuidString),teamID.eq.\(bestGame.team2ID.uuidString)")
                .neq("teamID", value: bestLog.teamID.uuidString)
                .execute()
            
            let myTeam = try JSONDecoder().decode(TeamTable.self, from: myTeamResponse.data)
            let opponentTeam = try JSONDecoder().decode(TeamTable.self, from: opponentTeamResponse.data)
            
            // Update UI
            DispatchQueue.main.async {
                self.bestGameMyTeamName.text = myTeam.teamName
                self.bestGameMyTeamLogo.image = UIImage(named: myTeam.teamLogo ?? "placeholder")
                self.bestGameOpponentTeamName.text = opponentTeam.teamName
                self.bestGameOpponentTeamLogo.image = UIImage(named: opponentTeam.teamLogo ?? "placeholder")
                self.bestGameMyTeam2pters.text = "\(bestLog.points2)"
                self.bestGameMyTeam3pters.text = "\(bestLog.points3)"
                self.bestGameMyTeamFreeThrows.text = "\(bestLog.freeThrows)"
            }
        } catch {
            print("Error displaying best game: \(error)")
        }
    }
    
    func fetchTeamsForUserSupabase(userID: UUID?) {
        guard let userID = userID else {
            print("User ID is nil")
            return
        }
        
        Task {
            do {
                // Fetch memberships for the current user
                let membershipsResponse = try await supabase
                    .from("teamMembership")
                    .select("*")
                    .eq("userID", value: userID.uuidString)
                    .execute()
                
                let decoder = JSONDecoder()
                let memberships = try decoder.decode([TeamMembershipTable].self, from: membershipsResponse.data)
                
                // Extract teamIDs from memberships
                let teamIDs = memberships.map { $0.teamID.uuidString }
                
                // Fetch teams matching the teamIDs
                let teamsResponse = try await supabase
                    .from("teams")
                    .select("*")
                    .in("teamID", values: teamIDs)
                    .execute()
                
                let teams2 = try decoder.decode([TeamTable].self, from: teamsResponse.data)
                
                print("Teams for user: \(teams2)")
                
                // Handle the fetched teams (update UI, etc.)
                teams11 = teams2
                teamCollectionView.reloadData()
            } catch {
                print("Error fetching teams: \(error)")
            }
        }
    }
    
    // MARK: - Fetch Posts
//    func fetchPosts() {
//        
//        posts1 = posts.filter { $0.createdBy == loggedInUserID }
//        tableView.reloadData()
//    }
    
    func fetchPosts() async {
        do {
            // Fetch posts created by the logged-in user
            let postsResponse = try await supabase.from("posts").select("*").eq("createdBy", value: sessionuser).execute()
            let postsDecoder = JSONDecoder()
            posts11 = try postsDecoder.decode([PostsTable].self, from: postsResponse.data)
            
            // Reload the table view with fetched data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching posts: \(error)")
        }
    }
    
    
    
    
    // MARK: FEED
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts11.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostCell", for: indexPath) as? ProfilePostCell else {
            return UITableViewCell()
        }
        
        // Fetch the post from the filtered posts array
        let poster = posts11[indexPath.row]
        
        // Configure cell with the post data
        // Configure cell asynchronously to fetch data from Supabase
        Task {
            do {
                // Fetch user data
                let userResponse = try await supabase.from("User").select("*").eq("userID", value: poster.createdBy).single().execute()
                let userDecoder = JSONDecoder()
                let user = try userDecoder.decode(Usertable.self, from: userResponse.data)
                
                DispatchQueue.main.async {
                    cell.athleteNameLabel.text = user.name
                    cell.profileImageView.image = UIImage(named: (user.profilePicture!.isEmpty ? "defaultProfile" : user.profilePicture) ?? " ")
                }
            } catch {
                print("Error fetching user data: \(error)")
                DispatchQueue.main.async {
                    cell.athleteNameLabel.text = " "
                    cell.profileImageView.image = UIImage(named: "defaultProfile")
                }
            }
            
            // Fetch linked game and team data if applicable
            if let linkedGameID = poster.linkedGameID {
                do {
                    let gameResponse = try await supabase.from("Game").select("*").eq("gameID", value: linkedGameID).single().execute()
                    let gameDecoder = JSONDecoder()
                    let game = try gameDecoder.decode(GameTable.self, from: gameResponse.data)
                    
                    let teamResponse = try await supabase.from("teams").select("*").eq("teamID", value: game.team1ID).single().execute()
                    let teamDecoder = JSONDecoder()
                    let team = try teamDecoder.decode(TeamTable.self, from: teamResponse.data)
                    
                    DispatchQueue.main.async {
                        cell.teamNameLabel.text = team.teamName
                        cell.teamLogoImageView.image = UIImage(named: (team.teamLogo!.isEmpty ? "defaultTeamLogo" : team.teamLogo) ?? " ")
                    }
                } catch {
                    print("Error fetching game or team data: \(error)")
                    DispatchQueue.main.async {
                        cell.teamNameLabel.text = " "
                        cell.teamLogoImageView.image = UIImage(named: "defaultTeamLogo")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.teamNameLabel.text = " "
                    cell.teamLogoImageView.image = UIImage(named: "defaultTeamLogo")
                }
            }
            
            // Configure post images
            DispatchQueue.main.async {
                cell.imageView1.image = UIImage(named: poster.image1)
                cell.imageView2.image = UIImage(named: poster.image2)
                cell.imageView3.image = UIImage(named: poster.image3)

            }
        }
        
        return cell
    }
}
// MARK: - UICollectionView
extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams11.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCollectionViewCell
        cell.configure(with: teams11[indexPath.row])
        return cell
    }
}

