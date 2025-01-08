//
//  ViewController.swift
//  MatchHistory
//
//  Created by admin65 on 14/11/24.
//

import UIKit

class MatchHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
  
    var games: [GameTable] = []
    var filteredGames: [GameTable] = []
    var teams: [TeamTable] = []
    var gameLogs: [GameLogtable] = []

    override func viewDidLoad() {
           super.viewDidLoad()
           
           tableView.dataSource = self
           searchBar.delegate = self
           
           Task {
               do {
                   try await fetchGamesAndTeams()
                   filteredGames = games
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
               } catch {
                   print("Error fetching data: \(error)")
               }
           }
       }
       
       // MARK: - Fetch Games, Teams, and Logs
    func fetchGamesAndTeams() async throws {
        guard let sessionUserID = SessionManager.shared.getSessionUser() else {
            print("Error: No session user is set")
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        // Fetch game logs for the logged-in user
        let gameLogsResponse = try await supabase
            .from("GameLog")
            .select("*")
            .eq("playerID", value: sessionUserID)
            .execute()
        gameLogs = try decoder.decode([GameLogtable].self, from: gameLogsResponse.data)

        // Extract game IDs from the user's game logs
        let userGameIDs = Set(gameLogs.map { $0.gameID })

        // Fetch games
        let gamesResponse = try await supabase
            .from("Game")
            .select("*")
            .in("gameID", values: Array(userGameIDs))
            .execute()
        games = try decoder.decode([GameTable].self, from: gamesResponse.data)

        // Fetch teams
        let teamsResponse = try await supabase
            .from("teams")
            .select("*")
            .execute()
        teams = try decoder.decode([TeamTable].self, from: teamsResponse.data)
    }

       
       // MARK: - Get game stats function
    func getGameStats(gameID: UUID) -> (team1Name: String, team1Logo: String, team2Name: String, team2Logo: String, team1Stats: [String: Int], team2Stats: [String: Int]) {
        guard let sessionUserID = SessionManager.shared.getSessionUser() else {
            fatalError("Error: No session user is set")
        }
        
        // Find the game by ID
        guard let game = games.first(where: { $0.gameID == gameID }) else {
            fatalError("Game not found")
        }
        
        // Retrieve the teams
        guard let team1 = teams.first(where: { $0.teamID == game.team1ID }),
              let team2 = teams.first(where: { $0.teamID == game.team2ID }) else {
            fatalError("Teams not found")
        }

        // Get the game logs for the game
        let team1GameLogs = gameLogs.filter { $0.gameID == gameID && $0.teamID == game.team1ID && $0.playerID == sessionUserID }
        let team2GameLogs = gameLogs.filter { $0.gameID == gameID && $0.teamID == game.team2ID && $0.playerID == sessionUserID }
           
        // Calculate total stats for Team 1
        let team1Stats = [
            "2pt Field Goals": team1GameLogs.reduce(0) { $0 + $1.points2 },
            "3pt Field Goals": team1GameLogs.reduce(0) { $0 + $1.points3 },
            "Free Throws": team1GameLogs.reduce(0) { $0 + $1.freeThrows }
        ]
        
        // Calculate total stats for Team 2
        let team2Stats = [
            "2pt Field Goals": team2GameLogs.reduce(0) { $0 + $1.points2 },
            "3pt Field Goals": team2GameLogs.reduce(0) { $0 + $1.points3 },
            "Free Throws": team2GameLogs.reduce(0) { $0 + $1.freeThrows }
        ]
        
        // Use a default value for optional team logos
        let team1Logo = team1.teamLogo ?? "default_logo"
        let team2Logo = team2.teamLogo ?? "default_logo"
        
        // Return the result
        return (team1Name: team1.teamName, team1Logo: team1Logo, team2Name: team2.teamName, team2Logo: team2Logo, team1Stats: team1Stats, team2Stats: team2Stats)
    }


       
       // MARK: - Search Functionality
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               filteredGames = games
           } else {
               filteredGames = games.filter { game in
                   guard let team1 = teams.first(where: { $0.teamID == game.team1ID }),
                         let team2 = teams.first(where: { $0.teamID == game.team2ID }) else {
                       return false
                   }
                   return team1.teamName.lowercased().contains(searchText.lowercased()) ||
                          team2.teamName.lowercased().contains(searchText.lowercased())
               }
           }
           tableView.reloadData()
       }

       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.text = ""
           filteredGames = games
           tableView.reloadData()
           searchBar.resignFirstResponder()
       }
       
       // MARK: - UITableViewDataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return filteredGames.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "MatchTableViewCell", for: indexPath) as! MatchTableViewCell
           let game = filteredGames[indexPath.row]
           let gameStats = getGameStats(gameID: game.gameID)
           cell.configure(with: gameStats)
           //print(cell)
           return cell
       }
       
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToStats" {
//            if let statsVC = segue.destination as? StatsViewController {
//                if let selectedGame = sender as? GameTable {
//                    statsVC.selectedGame = selectedGame
//                    print("*******")
//                    print("Selected Game: \(selectedGame)")
//                    
//                    //            var game101: GameTable?
//                    //
//                    //            if let game101 = game101 {
//                    //                        print("Selected Game ID: \(game101.gameID)")
//                    //                        // Populate UI elements using the game data
//                    //                    }
//                }
//            }
//        }
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = filteredGames[indexPath.row]
        
        // Initialize StatsViewController programmatically
        let statsVC = storyboard?.instantiateViewController(withIdentifier: "StatsViewController") as? StatsViewController
       // let statsVC = StatsViewController()
        statsVC!.selectedGame = selectedGame

        
        // Print debugging information
        print("Navigating to StatsViewController with selected game: \(selectedGame)")
        
        // Present the StatsViewController
        
        
        navigationController?.pushViewController(statsVC!, animated: true)
    }
   }
