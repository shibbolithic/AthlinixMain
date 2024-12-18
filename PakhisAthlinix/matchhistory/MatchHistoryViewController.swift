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
    
  
    
   // var games: [Game] = [] // Assuming you have a games array populated
       var filteredGames: [Game] = []
  //  var teams: [Teams] = [] // Array containing team data
    
    func createDate(day: Int, month: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        let calendar = Calendar.current
        return calendar.date(from: dateComponents) ?? Date()
    }

    override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.dataSource = self
            searchBar.delegate = self
            
            // Initialize your games array here
            // games = loadGames()  // e.g., fetch games from a database or API
        let gameStats = getGameStats(gameID: "game1")
        print(gameStats.team1Name)  // "Red Warriors"
        print(gameStats.team1Logo)  // "team1"
        print(gameStats.team1Stats)  // ["2pt Field Goals": 22, "3pt Field Goals": 5, "Free Throws": 7]
        print(gameStats.team2Name)  // "Blue Sharks"
        print(gameStats.team2Logo)  // "team2"
        print(gameStats.team2Stats)

            filteredGames = games
        }

    
    // MARK: - Search Functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGames = games // Show all games if search text is empty
        } else {
            filteredGames = games.filter { game in
                // Find home and away teams based on the team IDs
                guard let homeTeam = teams.first(where: { $0.teamID == game.team1ID }),
                      let awayTeam = teams.first(where: { $0.teamID == game.team2ID }) else {
                    return false // If no team found, exclude this game from the filter
                }
                
                // Compare search text with team names
                return homeTeam.teamName.lowercased().contains(searchText.lowercased()) ||
                       awayTeam.teamName.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData() // Refresh table view with the filtered data
    }

        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            filteredGames = games // Reset to show all games
            tableView.reloadData()
            searchBar.resignFirstResponder() // Dismiss the keyboard
        }
    
        // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredGames.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchTableViewCell", for: indexPath) as! MatchTableViewCell
            let game = filteredGames[indexPath.row]
            
            // Call getGameStats with the gameID
            let gameStats = getGameStats(gameID: game.gameID)
            
            // Pass the data from getGameStats to the cell
            cell.configure(with: gameStats)
            
            return cell
        }
    
    @IBAction func celltapped(_ sender: UIButton) {
        performSegue(withIdentifier: "gotostats" , sender: nil)
    }
    
    }




