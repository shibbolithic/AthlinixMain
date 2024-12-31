////
////  ViewController.swift
////  MATCHES
////
////  Created by admin65 on 15/11/24.
////
//
//import UIKit
//
//class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    @IBOutlet weak var team1Logo: UIImageView!
//    @IBOutlet weak var team2Logo: UIImageView!
//    @IBOutlet weak var team1Name: UILabel!
//    @IBOutlet weak var team1Score: UILabel!
//    @IBOutlet weak var team2Score: UILabel!
//    @IBOutlet weak var team2Name: UILabel!
//    
//    
//    @IBOutlet weak var segmentedController: UISegmentedControl!
//    
//    @IBOutlet weak var labelStackView: UIStackView!
//    @IBOutlet weak var playerStackView: UITableView!
//    
//    @IBOutlet weak var playerLabel: UILabel!
//    
//        var selectedGame: Game!
//        var selectedTeam: Teams!
//        var stats: [(category: String, team1Value: Int, team2Value: Int)] = []
//    
//    
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            playerStackView.dataSource = self
//            playerStackView.delegate = self
//
//            // Select the first game by default
//            selectedGame = games.first
//
//            if let selectedGame = selectedGame {
//                // Fetch team data
//                let team1 = teams.first { $0.teamID == selectedGame.team1ID }
//                let team2 = teams.first { $0.teamID == selectedGame.team2ID }
//
//                guard let team1 = team1, let team2 = team2 else {
//                    fatalError("Teams not found for the selected game.")
//                }
//
//                // Calculate team scores
//                let team1ScoreValue = calculateTeamScore(teamID: team1.teamID, gameID: selectedGame.gameID)
//                let team2ScoreValue = calculateTeamScore(teamID: team2.teamID, gameID: selectedGame.gameID)
//
//                // Set logos, names, and scores
//                team1Logo.image = UIImage(named: team1.teamLogo)
//                team2Logo.image = UIImage(named: team2.teamLogo)
//                team1Name.text = team1.teamName
//                team2Name.text = team2.teamName
//                team1Score.text = "\(team1ScoreValue)"
//                team2Score.text = "\(team2ScoreValue)"
//
//                // Update segment control titles
//                segmentedController.setTitle(team1.teamName, forSegmentAt: 0)
//                segmentedController.setTitle(team2.teamName, forSegmentAt: 1)
//                segmentedController.setTitle("Game Stats", forSegmentAt: 2)
//
//                // Populate stats
//                stats = calculateGameStats(gameID: selectedGame.gameID, team1ID: team1.teamID, team2ID: team2.teamID)
//
//                // Set default team
//                selectedTeam = team1
//            }
//        }
//
//        @IBAction func switchTableViewAction(_ sender: UISegmentedControl) {
//            switch sender.selectedSegmentIndex {
//            case 0, 1: // Team 1 or Team 2
//                labelStackView.isHidden = false
//                playerLabel.isHidden = false
//                playerStackView.isHidden = false
//
//                // Update selectedTeam based on the selected segment
//                selectedTeam = sender.selectedSegmentIndex == 0 ? teams.first { $0.teamID == selectedGame.team1ID } : teams.first { $0.teamID == selectedGame.team2ID }
//
//            case 2: // Game Stats
//                labelStackView.isHidden = true
//                playerLabel.isHidden = true
//                playerStackView.isHidden = false
//
//            default:
//                break
//            }
//
//            playerStackView.reloadData()
//        }
//
//        // UITableViewDataSource Methods
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch segmentedController.selectedSegmentIndex {
//        case 0, 1:
//            // Player stats segment
//            return gameLogs.filter { $0.teamID == selectedTeam.teamID && $0.gameID == selectedGame.gameID }.count
//        case 2:
//            // Game stats segment
//            return stats.count
//        default:
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatsCell", for: indexPath) as? playersStatsTableViewCell else {
//            return UITableViewCell()
//        }
//
//        switch segmentedController.selectedSegmentIndex {
//        case 0, 1: // Player stats
//            let playerLogs = gameLogs.filter { $0.teamID == selectedTeam.teamID && $0.gameID == selectedGame.gameID }
//            let playerLog = playerLogs[indexPath.row]
//            
//            // Get the player name by matching playerID with userID in users array
//            let playerName = users.first { $0.userID == playerLog.playerID }?.name ?? "Unknown Player"
//            
//            cell.resetCell()
//            cell.configure(with: playerLog, playerName: playerName) // Updated to include playerName
//            cell.setCategoryView(hidden: true) // Hide category-related labels
//            
//        case 2: // Game stats
//            let stat = stats[indexPath.row]
//            
//            cell.resetCell()
//            cell.configureCategoryCell(with: stat.category, team1Value: stat.team1Value, team2Value: stat.team2Value)
//            cell.setPlayerView(hidden: true) // Hide player-related labels
//            
//        default:
//            fatalError("Unhandled segment index")
//        }
//
//        return cell
//    }
//
//
//
//
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 45
//        }
//
//        // Helper Methods
//        private func calculateTeamScore(teamID: String, gameID: String) -> Int {
//            let teamLogs = gameLogs.filter { $0.teamID == teamID && $0.gameID == gameID }
//            return teamLogs.reduce(0) { $0 + ($1.points2 * 2) + ($1.points3 * 3) + $1.freeThrows }
//        }
//
//        private func calculateGameStats(gameID: String, team1ID: String, team2ID: String) -> [(category: String, team1Value: Int, team2Value: Int)] {
//            let team1Logs = gameLogs.filter { $0.teamID == team1ID && $0.gameID == gameID }
//            let team2Logs = gameLogs.filter { $0.teamID == team2ID && $0.gameID == gameID }
//
//            func statSum(for logs: [GameLog], keyPath: KeyPath<GameLog, Int>) -> Int {
//                return logs.reduce(0) { $0 + $1[keyPath: keyPath] }
//            }
//
//            return [
//                ("Field Goals", statSum(for: team1Logs, keyPath: \.points2), statSum(for: team2Logs, keyPath: \.points2)),
//                ("3P Field Goals", statSum(for: team1Logs, keyPath: \.points3), statSum(for: team2Logs, keyPath: \.points3)),
//                ("Free Throws", statSum(for: team1Logs, keyPath: \.freeThrows), statSum(for: team2Logs, keyPath: \.freeThrows)),
//                ("Rebounds", statSum(for: team1Logs, keyPath: \.rebounds), statSum(for: team2Logs, keyPath: \.rebounds)),
//                ("Assists", statSum(for: team1Logs, keyPath: \.assists), statSum(for: team2Logs, keyPath: \.assists)),
//                ("Steals", statSum(for: team1Logs, keyPath: \.steals), statSum(for: team2Logs, keyPath: \.steals)),
//                ("Fouls", statSum(for: team1Logs, keyPath: \.fouls), statSum(for: team2Logs, keyPath: \.fouls))
//            ]
//        }
//    }
