//
//  SAConfettiView.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/14/15.
//
//

import UIKit
import QuartzCore

public class SAConfettiView: UIView {

    public enum ConfettiType {
        case confetti
        case triangle
        case star
        case diamond
        case image(UIImage)
    }

    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var intensity: Float!
    public var type: ConfettiType!
    
    public var birthRate: Float = 6.0
    public var lifetime: Float = 14.0
    public var lifetimeRange: Float = 0
    public var velocity: Float = 350.0
    public var velocityRange: Float = 80.0
    public var emissionLongitude = CGFloat(Double.pi)
    public var emissionRange: CGFloat = CGFloat(Double.pi)
    public var spin: CGFloat = 3.5
    public var spinRange: Float = 4.0
    public var scaleSpeed: Float = -0.1
    public var alphaRange: Float = 0
    public var alphaSpeed: Float = 0
    
    private var active :Bool!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
            UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
            UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
            UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
            UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        intensity = 0.5
        type = .confetti
        active = false
    }

    public func startConfetti() {
        emitter = CAEmitterLayer()

        emitter.emitterPosition = CGPoint(x: frame.size.width / 2, y: 0)
        emitter.emitterShape = kCAEmitterLayerRectangle
        emitter.emitterSize = CGSize(width: frame.size.width * 1.6, height: 1)

        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color: color))
        }

        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }

    public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }

    func imageForType(type: ConfettiType) -> UIImage? {

        var fileName: String!

        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case let .image(customImage):
            return customImage
        }

        let path = Bundle(for: SAConfettiView.self).path(forResource: "SAConfettiView", ofType: "bundle")
        let bundle = Bundle(path: path!)
        let imagePath = bundle?.path(forResource: fileName, ofType: "png")
        let url = URL(fileURLWithPath: imagePath!)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error)
        }
        return nil
    }
    
    func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = birthRate * intensity
        confetti.lifetime = lifetime * intensity
        confetti.lifetimeRange = lifetimeRange
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(velocity * intensity)
        confetti.velocityRange = CGFloat(velocityRange * intensity)
        confetti.emissionLongitude = emissionLongitude
        confetti.emissionRange = emissionRange
        confetti.spin = spin
        confetti.spinRange = CGFloat(spinRange * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(scaleSpeed * intensity)
        confetti.alphaRange = alphaRange
        confetti.alphaSpeed = alphaSpeed
        confetti.contents = imageForType(type: type)!.cgImage
        return confetti
    }

    public func isActive() -> Bool {
    		return self.active
    }
}
