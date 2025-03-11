import SwiftUI
import Charts

struct PointsScoredChart: View {
    let gameLogs: [GameLogtable]
    let games: [GameTable]

    var chartData: [(String, Int)] {
        gameLogs.compactMap { log in
            guard let game = games.first(where: { $0.gameID == log.gameID }) else { return nil }
            return (game.dateOfGame, log.totalPoints + log.freeThrows) // Sum of all points
        }
        .sorted { $0.0 < $1.0 } // Sort by game date
    }

    var body: some View {
        VStack {
            Text("Points Scored per Game")
                .font(.headline)

            Chart {
                ForEach(chartData, id: \.0) { game in
                    LineMark(
                        x: .value("Game", game.0),
                        y: .value("Points", game.1)
                    )
                    .foregroundStyle(.blue)
                    .symbol(.circle)
                }
            }
            .chartYScale(domain: 0...)
            .frame(height: 300)
        }
        .padding()
    }
}
