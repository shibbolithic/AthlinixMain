//
//  PointsScoredBarChartView.swift
//  GamePlay
//
//  Created by admin65 on 19/11/24.
//

import UIKit


class PointsScoredBarChartView: UIView {
    
    // Define years dynamically or hardcode specific years
    let years = ["2024", "2023", "2022", "2021", "2020"]
    var values: [CGFloat] = []

//    var loggedInUserID: String = "1" // Example logged-in user ID
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        calculateValuesForLoggedInUser()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        calculateValuesForLoggedInUser()
    }
    
    private func calculateValuesForLoggedInUser() {
        // Initialize values with zeros for each year
        var yearScores: [String: CGFloat] = years.reduce(into: [:]) { $0[$1] = 0 }
        
        // Process game logs to calculate points scored by the logged-in user
        for gameLog in gameLogs where gameLog.playerID == loggedInUserID {
            if let game = games.first(where: { $0.gameID == gameLog.gameID }),
               let year = Calendar.current.dateComponents([.year], from: game.dateOfGame).year {
                let yearString = String(year)
                if yearScores[yearString] != nil {
                    yearScores[yearString]! += CGFloat(gameLog.points2 * 2 + gameLog.points3 * 3 + gameLog.freeThrows)
                }
            }
        }
        
        // Map year scores to the values array
        values = years.map { yearScores[$0] ?? 0 }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Setup dimensions and styles
        let maxBarHeight: CGFloat = rect.height * 0.6
        let barWidth: CGFloat = rect.width / CGFloat(years.count) * 0.4
        let spacing: CGFloat = (rect.width / CGFloat(years.count)) * 0.6
        let maxValue = values.max() ?? 1
        let originY: CGFloat = rect.height * 0.8
        let baseColor = UIColor.systemPurple.withAlphaComponent(0.5)
        let lineColor = UIColor.systemRed
        
        // Draw grid lines and values
        let gridLineColor = UIColor.lightGray.withAlphaComponent(0.4)
        context.setStrokeColor(gridLineColor.cgColor)
        context.setLineWidth(1)
        
        let numGridLines = 5
        let gridValueSpacing = maxValue / CGFloat(numGridLines)
        let labelFont = UIFont.systemFont(ofSize: 12)
        let labelColor = UIColor.darkGray
        
        for i in 0...numGridLines {
            let y = originY - (CGFloat(i) / CGFloat(numGridLines) * maxBarHeight)
            
            // Draw grid line
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
            
            // Draw value labels for grid
            let gridValue = Int(gridValueSpacing * CGFloat(i))
            let valueLabel = UILabel()
            valueLabel.text = "\(gridValue)"
            valueLabel.font = labelFont
            valueLabel.textColor = labelColor
            valueLabel.sizeToFit()
            valueLabel.frame.origin = CGPoint(x: 4, y: y - valueLabel.frame.height / 2)
            self.addSubview(valueLabel)
        }
        context.strokePath()
        
        let leftMargin: CGFloat = 24
        // Draw bars and dots
        for (index, value) in values.enumerated() {
            let x = leftMargin + CGFloat(index) * (barWidth + spacing)
            let barHeight = (value / maxValue) * maxBarHeight
            let barRect = CGRect(x: x, y: originY - barHeight, width: barWidth, height: barHeight)
            
            context.setFillColor(baseColor.cgColor)
            context.fill(barRect)
            
            // Draw the dot
            let circleCenter = CGPoint(x: barRect.midX, y: barRect.minY)
            let circleRadius: CGFloat = 6
            context.setFillColor(lineColor.cgColor)
            context.addEllipse(in: CGRect(x: circleCenter.x - circleRadius,
                                          y: circleCenter.y - circleRadius,
                                          width: circleRadius * 2,
                                          height: circleRadius * 2))
            context.fillPath()
            
            // Draw year labels below bars
            let yearLabel = UILabel()
            yearLabel.text = years[index]
            yearLabel.font = labelFont
            yearLabel.textColor = labelColor
            yearLabel.textAlignment = .center
            yearLabel.sizeToFit()
            yearLabel.center = CGPoint(x: barRect.midX, y: originY + yearLabel.frame.height)
            self.addSubview(yearLabel)
        }
        
        // Draw connecting line
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(2)
        context.setLineJoin(.round)
        
        context.beginPath()
        for (index, value) in values.enumerated() {
            let x = CGFloat(index) * (barWidth + spacing) + spacing / 2 + barWidth / 2
            let y = originY - (value / maxValue) * maxBarHeight
            if index == 0 {
                context.move(to: CGPoint(x: x, y: y))
            } else {
                context.addLine(to: CGPoint(x: x, y: y))
            }
        }
        context.strokePath()
    }
}
