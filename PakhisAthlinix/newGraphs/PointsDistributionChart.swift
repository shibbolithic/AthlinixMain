import SwiftUI
import Charts
import Supabase

struct PointsDistributionChart: UIViewRepresentable {
    let gameLogs: [GameLogtable]

    func makeUIView(context: Context) -> BarChartView {
        let chartView = BarChartView()
        chartView.noDataText = "No game data available"
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: gameLogs.map { _ in "" }) // Placeholder for game labels
        chartView.legend.enabled = true
        chartView.legend.horizontalAlignment = .center
        chartView.leftAxis.axisMinimum = 0
        chartView.animate(yAxisDuration: 1.5)

        updateChartData(chartView: chartView)
        return chartView
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        updateChartData(chartView: uiView)
    }

    func updateChartData(chartView: BarChartView) {
        let latestGames = gameLogs.suffix(8)  // Get the latest 8 games
        let gameLabels = latestGames.map { "G\(gameLogs.firstIndex(of: $0)! + 1)" }  // Labels like G1, G2

        var entries: [BarChartDataEntry] = []

        for (index, log) in latestGames.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), yValues: [
                Double(log.points2 * 2), // 2-pointers
                Double(log.points3 * 3), // 3-pointers
                Double(log.freeThrows)   // Free throws
            ])
            entries.append(entry)
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Points Breakdown")
        dataSet.colors = [UIColor.blue, UIColor.green, UIColor.red] // Different colors for categories
        dataSet.stackLabels = ["2-Pointers", "3-Pointers", "Free Throws"]

        let data = BarChartData(dataSet: dataSet)
        chartView.data = data
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: gameLabels)
    }
}
