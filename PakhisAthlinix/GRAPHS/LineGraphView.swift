import UIKit

class GraphView: UIView {
    
    var gameDates: [String] = []
    var pointsScored: [CGFloat] = []
    var points: [CGPoint] = []
    var tooltipLabel: UILabel?

    func configureGraph(dates: [String], points: [CGFloat]) {
        self.gameDates = dates
        self.pointsScored = points
        self.points.removeAll()
        self.subviews.forEach { $0.removeFromSuperview() } // Remove old labels
        setNeedsDisplay()
    }
    
//MARK: DRAW FUN
    override func draw(_ rect: CGRect) {
        guard gameDates.count > 1, pointsScored.count > 1 else { return }

        let margin: CGFloat = 40
        let spacing = (rect.width - 2 * margin) / CGFloat(gameDates.count - 1)

        let maxPoints = pointsScored.max() ?? 1
        let minPoints = pointsScored.min() ?? 0
        let heightScale = (rect.height - 2 * margin) / (maxPoints - minPoints)

        points.removeAll()
        for (index, point) in pointsScored.enumerated() {
            let x = margin + CGFloat(index) * spacing
            let y = rect.height - margin - (point - minPoints) * heightScale
            points.append(CGPoint(x: x, y: y))
        }

        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        context?.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.3).cgColor)

        // Draw grid lines
        for i in 0..<gameDates.count {
            let x = margin + CGFloat(i) * spacing
            context?.move(to: CGPoint(x: x, y: margin))
            context?.addLine(to: CGPoint(x: x, y: rect.height - margin))
        }
        context?.strokePath()

        let path = UIBezierPath()
        path.move(to: points.first!)

        for i in 1..<points.count {
            let midPoint = CGPoint(x: (points[i].x + points[i - 1].x) / 2,
                                   y: (points[i].y + points[i - 1].y) / 2)
            path.addQuadCurve(to: midPoint, controlPoint: CGPoint(x: points[i - 1].x, y: points[i].y))
            path.addQuadCurve(to: points[i], controlPoint: CGPoint(x: points[i].x, y: points[i - 1].y))
        }

        let graphLayer = CAShapeLayer()
        graphLayer.path = path.cgPath
        graphLayer.strokeColor = UIColor.orange.cgColor
        graphLayer.lineWidth = 3
        graphLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(graphLayer)

        // Highlight last data point
        if let lastPoint = points.last {
            let circlePath = UIBezierPath(arcCenter: lastPoint, radius: 10, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            let highlightLayer = CAShapeLayer()
            highlightLayer.path = circlePath.cgPath
            highlightLayer.fillColor = UIColor.orange.cgColor
            self.layer.addSublayer(highlightLayer)

            // Dashed vertical line
            let dashedPath = UIBezierPath()
            dashedPath.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            dashedPath.addLine(to: CGPoint(x: lastPoint.x, y: rect.height - margin))

            let dashedLayer = CAShapeLayer()
            dashedLayer.path = dashedPath.cgPath
            dashedLayer.strokeColor = UIColor.orange.cgColor
            dashedLayer.lineDashPattern = [4, 4]
            dashedLayer.lineWidth = 2
            self.layer.addSublayer(dashedLayer)
        }

        // Add month labels
        for (index, month) in gameDates.enumerated() {
            let label = UILabel(frame: CGRect(x: margin + CGFloat(index) * spacing - 15, y: rect.height - margin + 5, width: 30, height: 15))
            label.text = month
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .center
            label.textColor = UIColor.darkGray
            self.addSubview(label)
        }

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        let closestPoint = points.enumerated().min(by: { abs($0.1.x - touchPoint.x) < abs($1.1.x - touchPoint.x) })?.offset

        guard let index = closestPoint else { return }
        let selectedPoint = points[index]
        let value = pointsScored[index]

        showTooltip(at: selectedPoint, value: value)
    }

    func showTooltip(at point: CGPoint, value: CGFloat) {
        tooltipLabel?.removeFromSuperview() // Remove existing tooltip if any

        let label = UILabel(frame: CGRect(x: point.x - 20, y: point.y - 30, width: 50, height: 25))
        label.backgroundColor = UIColor.orange
        label.textColor = .white
        label.textAlignment = .center
        label.text = "\(Int(value))"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true

        self.addSubview(label)
        tooltipLabel = label

        // Fade out after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.3, animations: {
                label.alpha = 0
            }) { _ in
                label.removeFromSuperview()
            }
        }
    }
}
