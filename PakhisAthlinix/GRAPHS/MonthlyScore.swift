import SwiftUI
import Charts

struct MonthlyScore: Identifiable {
    let id = UUID()
    let month: String
    let score: CGFloat
}

struct YearlyChartView: View {
    @State private var data: [MonthlyScore] = []
    @State private var selectedMonth: String? = nil

    private func fetchDataForYear(_ year: Int) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
            print("Error: No session user is set")
            return
        }
        
        do {
            let gameLogsResponse = try await supabase
                .from("GameLog")
                .select("*")
                .eq("playerID", value: sessionUserID.uuidString)
                .execute()
            let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogsResponse.data)
            
            let gamesResponse = try await supabase
                .from("Game")
                .select("*")
                .execute()
            let games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)
            
            var monthlyScores: [String: CGFloat] = [
                "Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0,
                "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0
            ]
            
            for gameLog in gameLogs {
                if let game = games.first(where: { $0.gameID == gameLog.gameID }),
                   let date = dateFormatter.date(from: game.dateOfGame),
                   let gameYear = Calendar.current.dateComponents([.year], from: date).year,
                   let gameMonthIndex = Calendar.current.dateComponents([.month], from: date).month,
                   gameYear == year {
                    
                    let monthName = dateFormatter.shortMonthSymbols[gameMonthIndex - 1]
                    monthlyScores[monthName]! += CGFloat(gameLog.points2 * 2 + gameLog.points3 * 3 + gameLog.freeThrows)
                }
            }
            
            DispatchQueue.main.async {
                self.data = monthlyScores.map { MonthlyScore(month: $0.key, score: $0.value) }.sorted { $0.month < $1.month }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Chart {
                ForEach(data) { entry in
                    LineMark(
                        x: .value("Month", entry.month),
                        y: .value("Points", entry.score)
                    )
                    .foregroundStyle(Color.orange)
                    .interpolationMethod(.catmullRom)

                    if selectedMonth == entry.month {
                        RuleMark(
                            x: .value("Month", entry.month)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundStyle(Color.orange)

                        PointMark(
                            x: .value("Month", entry.month),
                            y: .value("Points", entry.score)
                        )
                        .symbol(Circle().strokeBorder(Color.orange, lineWidth: 2).background(Circle().fill(Color.orange)))
                        .annotation(position: .top, alignment: .center) {
                            Text("\(Int(entry.score)) pts")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .frame(height: 300)
            .padding()
        }
        .onAppear {
            Task {
                await fetchDataForYear(2024) // Fetch for the current year initially
            }
        }
        .onTapGesture { location in
            let nearestEntry = data.min(by: { abs($0.score - location.x) < abs($1.score - location.x) })
            selectedMonth = nearestEntry?.month
        }
    }
}
