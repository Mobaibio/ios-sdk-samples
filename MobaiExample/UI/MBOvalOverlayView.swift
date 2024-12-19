//
//  MBOvalOverlayView.swift
//  MobaiBiometric
//

import UIKit


internal enum OvalStrokeColorSelected {
    case red
    case green
    case yellow
}

internal class MBOvalOverlayView: UIView {
    public var overlayFrame: CGRect = .zero
    private let screenBounds = UIScreen.main.bounds
    private var ovalLayer = CAShapeLayer()
    private let fillLayer = CAShapeLayer()
    private var regionOfIntereseSize: CGRect = .zero
    
    public init() {
        super.init(frame: .zero)
    }
    
    public override func layoutSubviews() {
        let ovalWidth = bounds.height * 0.35
        let ovalHeight = bounds.height * 0.45
        let ovalLeft = (bounds.width - ovalWidth) / 2
        let ovalTop = (bounds.height - ovalHeight) / 2
        overlayFrame = CGRect(x: ovalLeft, y: ovalTop, width: ovalWidth, height: ovalHeight)
        draw()
    }
    
    public func updateView(regionOfIntereseSize: CGRect) {
        self.regionOfIntereseSize = regionOfIntereseSize
        layoutSubviews()
    }
    
    private func draw() {
        let overlayPath = UIBezierPath(rect: bounds)
        let ovalPath = UIBezierPath(ovalIn: overlayFrame)
        overlayPath.append(ovalPath)
        overlayPath.usesEvenOddFillRule = true

        ovalLayer.path = ovalPath.cgPath
        ovalLayer.fillColor = UIColor.clear.cgColor
        ovalLayer.strokeColor = UIColor.yellow.cgColor
        ovalLayer.lineWidth = 5.0

        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.withAlphaComponent(0.2).cgColor

        layer.insertSublayer(ovalLayer, at: 1)
        layer.insertSublayer(fillLayer, at: 0)
    }
    
    public func updateOvalStrokeColor(_ color: OvalStrokeColorSelected) {
        switch color {
        case .red:
            ovalLayer.strokeColor = UIColor.red.cgColor
        case .green:
            ovalLayer.strokeColor = UIColor.green.cgColor
        case .yellow:
            ovalLayer.strokeColor = UIColor.yellow.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
