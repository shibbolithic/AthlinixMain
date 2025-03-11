import SwiftUI
import Charts
import Supabase

struct PointsVsDefenseChartView: View {
    @State private var gameLogs: [GameLogtable] = []
    @State private var games: [GameTable] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                Chart {
                    ForEach(gameLogs, id: \.logID) { log in
                        if let game = games.first(where: { $0.gameID == log.gameID }) {
                            let gameNumber = games.firstIndex(where: { $0.gameID == log.gameID }) ?? 0
                            let defensiveImpact = log.rebounds + log.steals
                            
                            BarMark(
                                x: .value("Game", gameNumber),
                                y: .value("Total Points", log.totalPoints)
                            )
                            .foregroundStyle(Color.blue)
                            
                            LineMark(
                                x: .value("Game", gameNumber),
                                y: .value("Defensive Contributions", defensiveImpact)
                            )
                            .foregroundStyle(Color.red)
                            .interpolationMethod(.monotone)
                        }
                    }
                }
                .frame(height: 300)
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic) { value in
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                .chartYAxis(.trailing) {
                    AxisMarks(position: .trailing, values: .automatic) { value in
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                .padding()
            }
        }
        .task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
                print("Error: No session user is set")
                isLoading = false
                return
            }
            
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
            
            isLoading = false
        } catch {
            print("Error fetching data: \(error)")
            isLoading = false
        }
    }
}
