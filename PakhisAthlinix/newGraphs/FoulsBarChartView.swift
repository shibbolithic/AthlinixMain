import SwiftUI
import Charts

struct FoulsBarChartView: View {
    @State private var gameFouls: [(game: String, fouls: Int)] = []
    @State private var isLoading = true

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                Chart {
                    ForEach(gameFouls, id: \.game) { data in
                        BarMark(
                            x: .value("Game", data.game),
                            y: .value("Fouls", data.fouls)
                        )
                        .foregroundStyle(.red)
                    }
                }
                .chartYAxisLabel("Fouls")
                .chartXAxisLabel("Games")
                .frame(height: 300)
                .padding()
            }
        }
        .onAppear {
            Task {
                await fetchData()
            }
        }
    }

    func fetchData() async {
        guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
            print("Error: No session user is set")
            isLoading = false
            return
        }

        do {
            let gameLogsResponse = try await supabase
                .from("GameLog")
                .select("*")
                .eq("playerID", value: sessionUserID.uuidString)
                .order("gameID", ascending: false) // Get latest games
                .limit(8)
                .execute()

            let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogsResponse.data)

            let gamesResponse = try await supabase
                .from("Game")
                .select("*")
                .execute()

            let games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)

            // Create a mapping of gameID to game date
            let gameDict = Dictionary(uniqueKeysWithValues: games.map { ($0.gameID, $0.dateOfGame) })

            // Map data for the bar chart
            gameFouls = gameLogs.map { log in
                let gameDate = gameDict[log.gameID] ?? "Unknown"
                return (game: gameDate, fouls: log.fouls)
            }
            .sorted { $0.game > $1.game } // Sort by latest date

            isLoading = false
        } catch {
            print("Error fetching data: \(error)")
            isLoading = false
        }
    }
}
