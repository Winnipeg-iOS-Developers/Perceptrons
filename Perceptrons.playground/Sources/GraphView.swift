import UIKit

public class GraphView: UIView {
    private let verticalLineView = UIView()
    private let horizontalLineView = UIView()
    
    private let lineColor: UIColor = .lightGray
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        verticalLineView.backgroundColor = lineColor
        horizontalLineView.backgroundColor = lineColor
        
        self.addSubview(verticalLineView)
        self.addSubview(horizontalLineView)
        
        self.backgroundColor = .white
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth: CGFloat = 1.0
        
        self.verticalLineView.frame = CGRect(
            x: self.bounds.midX - (lineWidth / 2),
            y: 0,
            width: lineWidth,
            height: self.bounds.maxY
        )
        
        self.horizontalLineView.frame = CGRect(
            x: 0,
            y: self.bounds.midY - (lineWidth / 2),
            width: self.bounds.width,
            height: lineWidth
        )
    }
    
    public func drawPoint(from inputs: [Int], as result: Int) {
        let pointDiameter: CGFloat = 10
        let pointRadius: CGFloat = pointDiameter / 2
        
        let inputX = CGFloat(inputs[0])
        let inputY = CGFloat(inputs[1])
        
        let translatedX = self.viewsXValue(fromGraphsXValue: inputX) - pointRadius
        let translatedY = self.viewsYValue(fromGraphsYValue: inputY) - pointRadius
        
        let frame = CGRect(
            x: translatedX,
            y: translatedY,
            width: pointDiameter,
            height: pointDiameter
        )
        let pointView = UIView(frame: frame)
        let aboveLine = result > 0
        pointView.backgroundColor = aboveLine ? .red : .blue
        pointView.layer.masksToBounds = true
        pointView.layer.cornerRadius = pointRadius
        
        self.addSubview(pointView)
    }
    
    private func viewsXValue(fromGraphsXValue graphXValue: CGFloat) ->  CGFloat {
        return self.bounds.width * CGFloat(graphXValue + 100) / 200.0
    }
    
    private func viewsYValue(fromGraphsYValue graphYValue: CGFloat) ->  CGFloat {
        return self.bounds.height - (self.bounds.height * CGFloat(graphYValue + 100) / 200.0)
    }
    
    public func drawLinearFunction(a: Int, b: Int) {
        let linearFunction: ((CGFloat) -> CGFloat) = { x in
            return (CGFloat(a) * x) + CGFloat(b)
        }
        
        let leadingX = viewsXValue(fromGraphsXValue: -100)
        let leadingY = viewsYValue(fromGraphsYValue: linearFunction(-100))
        let leadingPoint = CGPoint(x: leadingX, y: leadingY)
        
        let trailingX = viewsXValue(fromGraphsXValue: 100)
        let trailingY = viewsYValue(fromGraphsYValue: linearFunction(100))
        let trailingPoint = CGPoint(x: trailingX, y: trailingY)
        
        // Draw line
        let linePath = UIBezierPath()
        
        linePath.move(to: leadingPoint)
        linePath.addLine(to: trailingPoint)
        
        let line = CAShapeLayer()
        line.path = linePath.cgPath
        line.strokeColor = UIColor.black.cgColor
        line.lineWidth = 1.0
        line.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(line)
    }
}
