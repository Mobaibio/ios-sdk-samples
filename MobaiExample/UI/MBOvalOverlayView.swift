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
        overlayFrame = CGRect(
            x: (screenBounds.width - 300.0) / 2,
            y: (screenBounds.height - 400.0) / 2,
            width: 300.0,
            height: 400.0
        )
        
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
