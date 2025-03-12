//import SwiftUI
//import Charts
//import Supabase
//
//struct ContentView: View {
//    @State private var monthlyPoints: [MonthlyPoints] = []
//
//    var body: some View {
//        VStack {
//            if monthlyPoints.isEmpty {
//                ProgressView()
//            } else {
//                PointsChart(monthlyPoints: monthlyPoints)
//                    .frame(height: 300)
//                    .padding()
//            }
//        }
//        .task {
//            await fetchData()
//        }
//    }
//
//    func fetchData() async {
//        do {
//            let gameLogsResponse = try await supabase
//                .from("GameLog")
//                .select("*")
//                .eq("playerID", value: sessionUserID.uuidString)
//                .execute()
//
//            let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogsResponse.data)
//
//            let gamesResponse = try await supabase
//                .from("Game")
//                .select("*")
//                .execute()
//
//            let games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)
//
//            // Aggregate points per month
//            let groupedPoints = Dictionary(grouping: gameLogs, by: { log in
//                games.first { $0.gameID == log.gameID }?.month ?? "Unknown"
//            }).mapValues { logs in
//                logs.reduce(0) { $0 + $1.totalPoints }
//            }
//
//            let sortedData = groupedPoints.map { MonthlyPoints(month: $0.key, points: $0.value) }
//                .sorted { $0.dateValue < $1.dateValue }
//
//            await MainActor.run {
//                self.monthlyPoints = sortedData
//            }
//        } catch {
//            print("Error fetching data: \(error)")
//        }
//    }
//}
//
//// MARK: - Chart View
//struct PointsChart: View {
//    let monthlyPoints: [MonthlyPoints]
//
//    var body: some View {
//        Chart(monthlyPoints) { data in
//            LineMark(
//                x: .value("Month", data.month),
//                y: .value("Points", data.points)
//            )
//            .interpolationMethod(.catmullRom)
//            .foregroundStyle(.orange)
//            .lineStyle(StrokeStyle(lineWidth: 3))
//
//            PointMark(
//                x: .value("Month", data.month),
//                y: .value("Points", data.points)
//            )
//            .foregroundStyle(.orange)
//            .symbolSize(40)
//
//            if let last = monthlyPoints.last {
//                if data.id == last.id {
//                    AnnotationMark(
//                        x: .value("Month", last.month),
//                        y: .value("Points", last.points)
//                    ) {
//                        Circle()
//                            .fill(Color.orange)
//                            .frame(width: 12, height: 12)
//                            .overlay(
//                                Circle()
//                                    .stroke(Color.white, lineWidth: 2)
//                            )
//                    }
//                    RuleMark(
//                        x: .value("Month", last.month)
//                    )
//                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
//                    .foregroundStyle(.orange)
//                }
//            }
//        }
//        .chartXAxis {
//            AxisMarks(values: monthlyPoints.map { $0.month }) { _ in
//                AxisValueLabel()
//                    .foregroundStyle(.gray)
//            }
//        }
//    }
//}
//
//// MARK: - Models
//struct MonthlyPoints: Identifiable {
//    let id = UUID()
//    let month: String
//    let points: Int
//
//    var dateValue: Date {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM"
//        return formatter.date(from: month) ?? Date()
//    }
//}
//
//// Extension to extract the month from game date
//extension GameTable {
//    var month: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        guard let date = formatter.date(from: dateOfGame) else { return "Unknown" }
//        formatter.dateFormat = "MMM"
//        return formatter.string(from: date)
//    }
//}
//
//// MARK: - Preview
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleData: [MonthlyPoints] = [
//            MonthlyPoints(month: "May", points: 50),
//            MonthlyPoints(month: "Jun", points: 90),
//            MonthlyPoints(month: "Jul", points: 60),
//            MonthlyPoints(month: "Aug", points: 70),
//            MonthlyPoints(month: "Sep", points: 80),
//            MonthlyPoints(month: "Oct", points: 85),
//            MonthlyPoints(month: "Nov", points: 100)
//        ]
//
//        PointsChart(monthlyPoints: sampleData)
//            .frame(height: 300)
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}
