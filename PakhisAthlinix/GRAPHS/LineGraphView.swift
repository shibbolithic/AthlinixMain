import UIKit

class LineGraphView: UIView {
    var gameLogs: [GameLogtable] = []
    var games: [GameTable] = []
    
    private var pathLayer = CAShapeLayer()
    private var dotLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
    }

    override func draw(_ rect: CGRect) {
        guard !gameLogs.isEmpty, !games.isEmpty else { return }
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        
        let graphPath = UIBezierPath()
        
        let monthData = processMonthlyPoints()
        guard monthData.count > 1 else { return }
        
        let xGap = rect.width / CGFloat(monthData.count - 1)
        let maxYValue = (monthData.map { $0.points }.max() ?? 1) * 1.2
        let yScale = rect.height / maxYValue
        
        let points = monthData.enumerated().map { (index, data) -> CGPoint in
            let x = CGFloat(index) * xGap
            let y = rect.height - (data.points * yScale)
            return CGPoint(x: x, y: y)
        }
        
        graphPath.move(to: points[0])
        for point in points.dropFirst() {
            graphPath.addLine(to: point)
        }
        
        // Set up line layer
        pathLayer.path = graphPath.cgPath
        pathLayer.strokeColor = UIColor.systemOrange.cgColor
        pathLayer.lineWidth = 3
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineJoin = .round
        layer.addSublayer(pathLayer)

        animateGraph()
        
        // Draw the dot at last point
        drawDot(at: points.last ?? .zero)
    }
    
    private func processMonthlyPoints() -> [(month: String, points: CGFloat)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let grouped = Dictionary(grouping: gameLogs) { log in
            let date = games.first { $0.gameID == log.gameID }?.dateOfGame
            return date?.prefix(7) ?? ""
        }

        let sortedData = grouped.map { (key, logs) in
            let monthName = key.suffix(2)  // Extract MM from YYYY-MM
            let total = logs.reduce(0) { $0 + $1.totalPoints }
            return (String(monthName), CGFloat(total))
        }
        .sorted { $0.0 < $1.0 }

        return sortedData
    }
    
    private func animateGraph() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathLayer.add(animation, forKey: "lineAnimation")
    }

    private func drawDot(at point: CGPoint) {
        let dotPath = UIBezierPath(arcCenter: point, radius: 6, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        dotLayer.path = dotPath.cgPath
        dotLayer.fillColor = UIColor.systemOrange.cgColor
        layer.addSublayer(dotLayer)
        
        let lineLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: point.x, y: bounds.height))
        linePath.addLine(to: point)
        
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.systemOrange.cgColor
        lineLayer.lineWidth = 1
        lineLayer.lineDashPattern = [4, 4]
        layer.addSublayer(lineLayer)
    }
}
