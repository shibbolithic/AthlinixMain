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
                    ForEach(gameLogs.indices, id: \.self) { index in
                        let log = gameLogs[index]
                        if let gameIndex = games.firstIndex(where: { $0.gameID == log.gameID }) {
                            let defensiveImpact = log.rebounds + log.steals
                            
                            // Bar for Total Points
                            BarMark(
                                x: .value("Game", gameIndex),
                                y: .value("Total Points", log.totalPoints)
                            )
                            .foregroundStyle(.blue)
                            .annotation(position: .top) {
                                Text("\(log.totalPoints)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }

                            // Line for Defensive Contributions
                            LineMark(
                                x: .value("Game", gameIndex),
                                y: .value("Defensive Contributions", defensiveImpact)
                            )
                            .foregroundStyle(.red)
                            .symbol(Circle())
                            .interpolationMethod(.monotone)
                            .annotation(position: .top) {
                                Text("\(defensiveImpact)")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .frame(height: 300)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                .chartForegroundStyleScale([
                    "Total Points": .blue,
                    "Defensive Contributions": .red
                ])
                .chartLegend(position: .bottom, alignment: .center, spacing: 8)
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
