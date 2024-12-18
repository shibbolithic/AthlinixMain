//
//  func.swift
//  PakhisAthlinix
//
//  Created by admin65 on 17/12/24.
//


func getGameStats(gameID: String) -> (team1Name: String, team1Logo: String, team2Name: String, team2Logo: String, team1Stats: [String: Int], team2Stats: [String: Int]) {
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
    let team1GameLogs = gameLogs.filter { $0.gameID == gameID && $0.teamID == game.team1ID }
    let team2GameLogs = gameLogs.filter { $0.gameID == gameID && $0.teamID == game.team2ID }
    
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
    
    // Return the result
    return (team1Name: team1.teamName, team1Logo: team1.teamLogo, team2Name: team2.teamName, team2Logo: team2.teamLogo, team1Stats: team1Stats, team2Stats: team2Stats)
}
