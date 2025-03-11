//
//  GameLogtable.swift
//  PakhisAthlinix
//
//  Created by admin65 on 11/03/25.
//


import SwiftUI
import Charts

struct GameLogtable: Codable, Equatable {
    let logID: UUID
    let gameID: UUID
    let teamID: UUID
    let playerID: UUID
    var points2: Int
    var points3: Int
    var freeThrows: Int
    var rebounds: Int
    var assists: Int
    var steals: Int
    var fouls: Int
    var missed2Points: Int
    var missed3Points: Int
    var totalPoints: Int {
        return points2 * 2 + points3 * 3
    }
    
    var fieldGoalPercentage: Double {
        let totalAttempts = points2 + points3 + missed2Points + missed3Points
        return totalAttempts > 0 ? Double(points2 + points3) / Double(totalAttempts) * 100 : 0.0
    }
}

struct GameTable: Codable, Equatable {
    let gameID: UUID
    var team1ID: UUID
    var team2ID: UUID
    var dateOfGame: String
    var venue: String
    var team1finalScore: Int
    var team2finalScore: Int
}

struct FieldGoalChartView: View {
    @State private var gameLogs: [GameLogtable] = []
    @State private var games: [GameTable] = []
    
    var latestFiveGames: [(date: String, fieldGoalPercentage: Double)] {
        let gameLogMap = Dictionary(grouping: gameLogs, by: { $0.gameID })
        return games
            .sorted { $0.dateOfGame > $1.dateOfGame } // Sort by latest date
            .prefix(5) // Take latest 5 games
            .compactMap { game in
                if let logs = gameLogMap[game.gameID] {
                    let totalFGPercentage = logs.map { $0.fieldGoalPercentage }.reduce(0, +) / Double(logs.count)
                    return (game.dateOfGame, totalFGPercentage)
                }
                return nil
            }
            .reversed() // Maintain chronological order
    }

    var body: some View {
        VStack {
            Text("Field Goal Efficiency Over Time")
                .font(.title)
                .padding()

            Chart(latestFiveGames, id: \.date) { game in
                LineMark(
                    x: .value("Game", game.date),
                    y: .value("FG%", game.fieldGoalPercentage)
                )
                .foregroundStyle(.blue)
                .symbol(Circle().fill(.blue))
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 300)
        }
        .task {
            await fetchGameData()
        }
    }
    
    func fetchGameData() async {
        do {
            let gameLogsResponse = try await supabase
                .from("GameLog")
                .select("*")
                .eq("playerID", value: sessionUserID.uuidString)
                .execute()
            gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogsResponse.data)
            
            let gamesResponse = try await supabase
                .from("Game")
                .select("*")
                .execute()
            games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
