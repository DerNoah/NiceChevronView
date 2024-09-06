//
//  ChevronView.swift
//  ios-vestis
//
//  Created by Noah Plützer on 03.09.24.
//

import UIKit

open class ChevronView: UIView {
    private let shapeLayer = CAShapeLayer()
    
    open var direction: Direction = .right {
        didSet {
            if direction.isOppositeDirection(of: oldValue) {
                arePointsInverted.toggle()
            }
            redrawShape(animated: isAnimated)
        }
    }
    
    open var lineWidth: CGFloat = 4 {
        didSet {
            shapeLayer.lineWidth = lineWidth
        }
    }
    
    open var shapePadding: CGFloat { 4 }
    
    open var isAnimated: Bool = true
    
    public override var tintColor: UIColor! {
        didSet {
            shapeLayer.strokeColor = tintColor.cgColor
        }
    }
    
    private var arePointsInverted: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        redrawShape(animated: false)
    }
    
    private func setup() {
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        
        layer.addSublayer(shapeLayer)
        
        redrawShape(animated: false)
    }
    
    func redrawShape(animated: Bool) {
        let newChevronPath = makeChevronPath()
        guard animated else {
            shapeLayer.path = newChevronPath
            return
        }
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.toValue = newChevronPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        shapeLayer.add(animation, forKey: nil)
    }
    
    private func makeChevronPath() -> CGPath {
        let chevronStartPoint = chevronStartPoint(
            bounds: bounds.size,
            direction: direction,
            padding: shapePadding
        )
        let chevronMidPoint = chevronMidPoint(
            bounds: bounds.size,
            direction: direction
        )
        let chevronEndPoint = chevronEndPoint(
            bounds: bounds.size,
            direction: direction,
            padding: shapePadding
        )
        
        let path = UIBezierPath()
        
        path.move(to: arePointsInverted ? chevronEndPoint : chevronStartPoint)
        path.addLine(to: chevronMidPoint)
        path.move(to: arePointsInverted ? chevronStartPoint : chevronEndPoint)
        path.addLine(to: chevronMidPoint)
        path.close()
        
        return path.cgPath
    }
    
    private func chevronStartPoint(bounds: CGSize, direction: Direction, padding: CGFloat) -> CGPoint {
        let thirdWidth = bounds.width / 3
        let thirdHeight = bounds.height / 3
        
        switch direction {
            case .left:
                return CGPoint(x: thirdWidth * 2, y: bounds.height - padding)
            case .right:
                return CGPoint(x: thirdWidth, y: padding)
            case .up:
                return CGPoint(x: padding, y: thirdHeight * 2)
            case .down:
                return CGPoint(x: bounds.height - padding, y: thirdHeight)
        }
    }
    
    private func chevronEndPoint(bounds: CGSize, direction: Direction, padding: CGFloat) -> CGPoint {
        let thirdWidth = bounds.width / 3
        let thirdHeight = bounds.height / 3
        
        switch direction {
            case .left:
                return CGPoint(x: thirdWidth * 2, y: padding)
            case .right:
                return CGPoint(x: thirdWidth, y: bounds.height - padding)
            case .up:
                return CGPoint(x: bounds.width - padding, y: thirdHeight * 2)
            case .down:
                return CGPoint(x: padding, y: thirdHeight)
        }
    }
    
    private func chevronMidPoint(bounds: CGSize, direction: Direction) -> CGPoint {
        let thirdWidth = bounds.width / 3
        let thirdHeight = bounds.height / 3
        
        switch direction {
            case .left:
                return CGPoint(x: thirdWidth, y: bounds.height / 2)
            case .right:
                return CGPoint(x: thirdWidth * 2, y: bounds.height / 2)
            case .up:
                return CGPoint(x: bounds.width / 2, y: thirdHeight)
            case .down:
                return CGPoint(x: bounds.width / 2, y: thirdHeight * 2)
        }
    }
}

public extension ChevronView {
    enum Direction: CaseIterable {
        case left
        case right
        case up
        case down
        
        func isOppositeDirection(of direction: Direction) -> Bool {
            switch self {
                case .left:
                    return direction == .right
                case .right:
                    return direction == .left
                case .up:
                    return direction == .down
                case .down:
                    return direction == .up
            }
        }
    }
}
