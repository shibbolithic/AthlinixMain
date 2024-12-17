//
//  ViewController.swift
//  GamePlay
//
//  Created by admin65 on 19/11/24.
//

import UIKit
import Charts

class GamePlayViewController: UIViewController {
    
    let loggedInPlayerID = "2" // Replace with the actual logged-in player ID
    
    
    @IBOutlet weak var totalPointsScoredView: UIView!
    @IBOutlet weak var totalPointsScoredLabel: UILabel!
    
    @IBOutlet weak var gamesPlayedView: UIView!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    
    @IBOutlet weak var scoringEfficiencyView: UIView!
    @IBOutlet weak var pointsPerGame: UILabel!
    @IBOutlet weak var percentageIncrease: UILabel!
    @IBOutlet weak var scoringEfficiencyLineGraphView: UIView!
    
    
    @IBOutlet weak var reboundsView: UIView!
    @IBOutlet weak var reboundsNumber: UILabel! //number of rebounds
    @IBOutlet weak var reboundsPercentageIncrease: UILabel!
    @IBOutlet weak var reboundsIncreaseLinceGraphView: UIView!
    
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var assistsToTurnoverLabel: UILabel! //will have ratio in "9:3" format
   
    
    @IBOutlet weak var pointsScoredView: UIView!
    //@IBOutlet weak var pointsScoredBarChartView: UIView!
    @IBOutlet weak var pointsScoredBarChartView: PointsScoredBarChartView! //year wise points scored by a player, in gradient shades of #962DFF.
    
    
    @IBOutlet weak var goalsVsBricksView: UIView!
    
    @IBOutlet weak var goalsPieChartView: GoalsPieChartView!
    
   // @IBOutlet weak var goalsVsBricksPieChartView: UIView! //pie chart having three circles telling, out of the number of goals made, how many where missed, in 2PTFGS, 3PTFGS and Free Throws.
    
    
    @IBOutlet weak var gamePerformanceView: UIView!
    
    @IBOutlet weak var gamePerformanceBarChartView: GamePerformanceBarChartView!
    
    //@IBOutlet weak var gamePerformanceBarChartView: UIView! //bar graph of the number of rebounds, free throws, 2ptg and 3ptfg made in different months of an year in colours:- #962DFF, #4A3AFF, #E0C6FD, #93AAFD
    
    @IBOutlet weak var teamPerformanceView: UIView!
    
    
    @IBOutlet weak var teamPerformanceBarChartView: TeamPerformanceBarGamePlayChartView!
    
    //bar graph of points scored by members of users team.
    
    @IBOutlet weak var teamPerformanceLabel: UILabel!
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Style views
              styleOuterCardView(totalPointsScoredView)
              styleOuterCardView(gamesPlayedView)
              styleOuterCardView(scoringEfficiencyView)
              styleOuterCardView(reboundsView)
              styleOuterCardView(statisticsView)
              styleOuterCardView(pointsScoredView)
              styleOuterCardView(goalsVsBricksView)
              styleOuterCardView(gamePerformanceView)
              styleOuterCardView(teamPerformanceView)
            
            
            if let pieChartView = goalsPieChartView as? GoalsPieChartView {
                    pieChartView.gameLogs = gameLogs
                    pieChartView.loadData()
                }
            
            // Filter logs for the logged-in athlete
            let playerGameLogs = gameLogs.filter { $0.playerID == loggedInPlayerID }
            guard !playerGameLogs.isEmpty else { return }
            
            // Calculate metrics
            let totalPoints = playerGameLogs.reduce(0) { $0 + ($1.points2 + $1.points3 + $1.freeThrows) }
            let gamesPlayed = playerGameLogs.count
            let pointsPerGameValue = Double(totalPoints) / Double(gamesPlayed)
            
            let firstGamePoints = playerGameLogs.first.map { $0.points2 + $0.points3 + $0.freeThrows } ?? 0
            let lastGamePoints = playerGameLogs.last.map { $0.points2 + $0.points3 + $0.freeThrows } ?? 0
            let scoringPercentageIncrease = firstGamePoints == 0 ? 0 : (Double(lastGamePoints - firstGamePoints) / Double(firstGamePoints)) * 100
            
            let totalRebounds = playerGameLogs.reduce(0) { $0 + $1.rebounds }
            let avgRebounds = Double(totalRebounds) / Double(gamesPlayed)
            
            let firstGameRebounds = playerGameLogs.first?.rebounds ?? 0
            let lastGameRebounds = playerGameLogs.last?.rebounds ?? 0
            let reboundsPercentageIncrease1 = firstGameRebounds == 0 ? 0 : (Double(lastGameRebounds - firstGameRebounds) / Double(firstGameRebounds)) * 100
            
            let totalAssists = playerGameLogs.reduce(0) { $0 + $1.assists }
            let totalTurnovers = playerGameLogs.reduce(0) { $0 + $1.fouls }
            let assistsToTurnoverRatio = totalTurnovers == 0 ? "N/A" : "\(totalAssists):\(totalTurnovers)"
            
            // Update UI
            totalPointsScoredLabel.text = "\(totalPoints)"
            gamesPlayedLabel.text = "\(gamesPlayed)"
            pointsPerGame.text = String(format: "%.1f", pointsPerGameValue)
            percentageIncrease.text = String(format: "%.2f%%", scoringPercentageIncrease)
            percentageIncrease.textColor = scoringPercentageIncrease < 0 ? .red : .green
            
            reboundsNumber.text = String(format: "%.1f", avgRebounds)
            reboundsPercentageIncrease.text = String(format: "%.2f%%", reboundsPercentageIncrease1)
            reboundsPercentageIncrease.textColor = reboundsPercentageIncrease1 < 0 ? .red : .green
            
            assistsToTurnoverLabel.text = assistsToTurnoverRatio
            
            // Graphs
            let pointsData = playerGameLogs.map { CGFloat($0.points2 + $0.points3 + $0.freeThrows) }
            let reboundsData = playerGameLogs.map { CGFloat($0.rebounds) }
           // let assistsToTurnoverData = playerGameLogs.map { CGFloat($0.assists - $0.fouls) } // Example ratio difference
            
            drawLineGraph(in: scoringEfficiencyLineGraphView, dataPoints: pointsData)
            drawLineGraph(in: reboundsIncreaseLinceGraphView, dataPoints: reboundsData)
//            drawLineGraph(in: assistsToTurnoverLineGraphView, dataPoints: assistsToTurnoverData)
            
//            let assistsToTurnoverPairs = playerGameLogs.map { (CGFloat($0.assists), CGFloat($0.fouls)) }
//               drawScatterPlot(in: assistsToTurnoverLineGraphView, dataPoints: assistsToTurnoverPairs)
            
        }

        // Styling function remains the same
        func styleOuterCardView(_ view: UIView) {
            view.layer.cornerRadius = 10
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.1
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
        }
        
        // Graph drawing function remains the same
        func drawLineGraph(in view: UIView, dataPoints: [CGFloat]) {
            let path = UIBezierPath()
            let width = view.bounds.width
            let height = view.bounds.height
            let maxDataPoint = dataPoints.max() ?? 1
            
            path.move(to: CGPoint(x: 0, y: height - (dataPoints[0] / maxDataPoint * height)))
            
            for (index, value) in dataPoints.enumerated() {
                let x = CGFloat(index) * (width / CGFloat(dataPoints.count - 1))
                let y = height - (value / maxDataPoint * height)
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.systemRed.cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1.5
            shapeLayer.add(animation, forKey: "lineAnimation")
            
            view.layer.addSublayer(shapeLayer)
            
            for (index, value) in dataPoints.enumerated() {
                let x = CGFloat(index) * (width / CGFloat(dataPoints.count - 1))
                let y = height - (value / maxDataPoint * height)
                let dot = UIView(frame: CGRect(x: x - 2.5, y: y - 2.5, width: 5, height: 5))
                dot.backgroundColor = UIColor.systemRed
                dot.layer.cornerRadius = 2.5
                view.addSubview(dot)
            }
        }
    // New scatter plot function
    func drawScatterPlot(in view: UIView, dataPoints: [(CGFloat, CGFloat)]) {
        let width = view.bounds.width
        let height = view.bounds.height
        
        // Determine max values for scaling
        let maxAssists = dataPoints.map { $0.0 }.max() ?? 1
        let maxTurnovers = dataPoints.map { $0.1 }.max() ?? 1
        
        // Add dots for each assist-turnover pair
        for (assists, turnovers) in dataPoints {
            let x = assists / maxAssists * width
            let y = height - (turnovers / maxTurnovers * height) // Invert Y-axis for UI coordinate system
            let dot = UIView(frame: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
            dot.backgroundColor = UIColor.systemBlue
            dot.layer.cornerRadius = 4
            view.addSubview(dot)
        }
        
        // Add axes
        addAxes(to: view)
    }

    // Helper function to add axes
    func addAxes(to view: UIView) {
        let width = view.bounds.width
        let height = view.bounds.height
        
        let xAxis = UIView(frame: CGRect(x: 0, y: height - 1, width: width, height: 1))
        xAxis.backgroundColor = .black
        view.addSubview(xAxis)
        
        let yAxis = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: height))
        yAxis.backgroundColor = .black
        view.addSubview(yAxis)
    }
    }

  
