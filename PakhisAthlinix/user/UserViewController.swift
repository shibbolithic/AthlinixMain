//
//  ViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 16/12/24.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var loggedinuser = "2"
    
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
    var posts1: [Post] = []
    var bestGame: Game?
    var gameLogs1: [GameLog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch primary data
        setupPrimaryData(forUserID: loggedinuser) // Example: Fetch data for userID "1"
        
        // Set up UI
        setupProfileDetails()
        fetchTeams()
        fetchPosts()
        displayBestGame()
        
        if let bestMatch = fetchBestMatch(forPlayerID: loggedinuser) {
            updatePinnedMatchView(with: bestMatch)
        }
        // Set delegates and data sources
        teamCollectionView.delegate = self
        teamCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Fetch and Assign Primary Data
    func setupPrimaryData(forUserID userID: String) {
        // Find user with matching userID
        if let matchedUser = users.first(where: { $0.userID == userID }) {
            user = matchedUser
        }
        
        // Find athlete profile with matching athleteID
        if let matchedAthleteProfile = athleteProfiles.first(where: { $0.athleteID == userID }) {
            athleteProfile = matchedAthleteProfile
        }
    }
    // MARK: - Calculate Games Played
    func calculateGamesPlayed(forUserID userID: String) -> Int {
        // Extract unique game IDs
        let matchesPlayed = Set(gameLogs.filter { $0.playerID == loggedinuser }.map { $0.gameID }).count
        // Return the count of unique games
        return matchesPlayed
    }
    
    
    // MARK: - Setup Profile Details
    func setupProfileDetails() {
        guard let user = user else {
            print("User data is missing")
            return
        }
        
        // Set user profile details
        userName.text = user.name
        playerOrCoachLabel.text = user.role == .athlete ? "Athlete" : "Coach"
        userBio.text = user.bio
        profilePicture.image = UIImage(named: user.profilePicture)
        backgroundPicture.image = UIImage(named: user.coverPicture ?? "")
        
        // Set athlete-specific details if the user is an athlete
        if user.role == .athlete, let athleteProfile = athleteProfile {
            position.text = athleteProfile.position
            height.text = "\(athleteProfile.height) cm"
            weight.text = "\(athleteProfile.weight) kg"
            ppg.text = "\(athleteProfile.averagePointsPerGame)"
            bpg.text = "\(athleteProfile.averageReboundsPerGame)"
            ast.text = "\(athleteProfile.averageAssistsPerGame)"
            
            // Calculate and display the number of games played
            print("Logged-in User ID: \(loggedinuser)")
            print("Game Logs: \(gameLogs)")
            
            // Calculate and display matches played
            let matchesPlayed = Set(gameLogs.filter { $0.playerID == loggedinuser }.map { $0.gameID }).count
            print("Matches Played: \(matchesPlayed)") // Debugging
            
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
    
    // MARK: - Fetch Best Match
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
    
    // MARK: - Update UI
    func updatePinnedMatchView(with game: Game) {
        // Fetch team details
        guard let team1 = teams.first(where: { $0.teamID == game.team1ID }),
              let team2 = teams.first(where: { $0.teamID == game.team2ID }) else { return }
        
        // Update labels
        bestGameMyTeamName.text = team1.teamName
        bestGameOpponentTeamName.text = team2.teamName
        
        // Update images (use a placeholder or a utility for image loading)
        bestGameMyTeamLogo.image = UIImage(named: team1.teamLogo)
        bestGameOpponentTeamLogo.image = UIImage(named: team2.teamLogo)
        
        // Fetch game logs for the match
        let team1Logs = gameLogs.filter { $0.gameID == game.gameID && $0.teamID == game.team1ID }
        let team2Logs = gameLogs.filter { $0.gameID == game.gameID && $0.teamID == game.team2ID }
        
        // Calculate stats
        bestGameMyTeam2pters.text = "\(team1Logs.reduce(0) { $0 + $1.points2 })"
        bestGameMyTeam3pters.text = "\(team1Logs.reduce(0) { $0 + $1.points3 })"
        bestGameMyTeamFreeThrows.text = "\(team1Logs.reduce(0) { $0 + $1.freeThrows })"
        
        bestGameOpponentTeam2pters.text = "\(team2Logs.reduce(0) { $0 + $1.points2 })"
        bestGameOpponentTeam3pters.text = "\(team2Logs.reduce(0) { $0 + $1.points3 })"
        bestGameOpponentFreeThrows.text = "\(team2Logs.reduce(0) { $0 + $1.freeThrows })"
    }
    
    
    
    // MARK: - Fetch Teams
    func fetchTeams() {
        // Filter memberships for the current user and fetch their teams
        let memberships = teamMemberships.filter { $0.userID == user?.userID }
        teams1 = memberships.compactMap { membership in
            teams.first { $0.teamID == membership.teamID }
        }
        teamCollectionView.reloadData()
    }
    
    // MARK: - Fetch Posts
    func fetchPosts() {
        posts1 = posts.filter { $0.createdBy == loggedinuser }
        tableView.reloadData()
    }
    
    // MARK: - Display Best Game
    func displayBestGame() {
        // Example logic to find the best game based on total points
        let bestGameLog = gameLogs.filter { $0.playerID == user?.userID }.max { $0.totalPoints < $1.totalPoints }
        guard let bestLog = bestGameLog else { return }
        bestGame = games.first { $0.gameID == bestLog.gameID }
        
        // Populate UI with best game data
        guard let game = bestGame else { return }
        let myTeam = teams.first { $0.teamID == bestLog.teamID }
        let opponentTeam = teams.first { $0.teamID != bestLog.teamID && ($0.teamID == game.team1ID || $0.teamID == game.team2ID) }
        
        bestGameMyTeamName.text = myTeam?.teamName
        bestGameMyTeamLogo.image = UIImage(named: myTeam?.teamLogo ?? "")
        bestGameOpponentTeamName.text = opponentTeam?.teamName
        bestGameOpponentTeamLogo.image = UIImage(named: opponentTeam?.teamLogo ?? "")
        bestGameMyTeam2pters.text = "\(bestLog.points2)"
        bestGameMyTeam3pters.text = "\(bestLog.points3)"
        bestGameMyTeamFreeThrows.text = "\(bestLog.freeThrows)"
    }
    
    // MARK: FEED
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostCell", for: indexPath) as? ProfilePostCell else {
            return UITableViewCell()
        }
        
        // Fetch the post from the filtered posts array
        let post = posts1[indexPath.row]
        
        // Configure cell with the post data
        if let user = users.first(where: { $0.userID == post.createdBy }) {
            cell.athleteNameLabel.text = user.name
            cell.profileImageView.image = UIImage(named: user.profilePicture.isEmpty ? "defaultProfile" : user.profilePicture)
        } else {
            cell.athleteNameLabel.text = " "
            cell.profileImageView.image = UIImage(named: "defaultProfile")
        }
        
        if let linkedGameID = post.linkedGameID,
           let game = games.first(where: { $0.gameID == linkedGameID }),
           let team = teams.first(where: { $0.teamID == game.team1ID }) {
            cell.teamNameLabel.text = team.teamName
            cell.teamLogoImageView.image = UIImage(named: team.teamLogo.isEmpty ? "defaultTeamLogo" : team.teamLogo)
        } else {
            cell.teamNameLabel.text = "Unknown Team"
            cell.teamLogoImageView.image = UIImage(named: "defaultTeamLogo")
        }
        
        cell.imageView1.image = UIImage(named: post.image1)
        cell.imageView2.image = UIImage(named: post.image2)
        cell.imageView3.image = UIImage(named: post.image3)
        
        return cell
    }
}
// MARK: - UICollectionView
extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCollectionViewCell
        cell.configure(with: teams[indexPath.row])
        return cell
    }
}

// MARK: - UITableView
//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
//        cell.configure(with: posts[indexPath.row])
//        return cell
//    }
//}
