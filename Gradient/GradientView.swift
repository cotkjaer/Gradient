//
//  LinearGradientView.swift
//  Gradient
//
//  Created by Christian Otkjær on 03/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

@IBDesignable
public class GradientView: UIView
{
    // MARK: - Colors
    
    @IBInspectable
    public var startColor : UIColor = UIColor(white: 1, alpha: 1) { didSet { setNeedsGradientUpdate(oldValue != startColor) } }
    
    @IBInspectable
    public var endColor : UIColor = UIColor(white: 1, alpha: 0) { didSet { setNeedsGradientUpdate(oldValue != endColor) } }
    
    public var otherColors = Array<UIColor>() { didSet { setNeedsGradientUpdate(oldValue != otherColors) } }
    
    public var colors : [UIColor] { return [startColor] + otherColors + [endColor] }
    
    // MARK: - Anchors

    internal class var DefaultStartAnchor : CGPoint { return CGPoint(x: 0, y: 0) }
    
    @IBInspectable
    public var startAnchor : CGPoint = CGPointInfinity
        
        { didSet { setNeedsImageUpdate(oldValue != startAnchor) } }

    internal class var DefaultEndAnchor : CGPoint { return CGPoint(x: 0, y: 0) }

    @IBInspectable
    public var endAnchor : CGPoint = CGPointInfinity
        { didSet { setNeedsImageUpdate(oldValue != endAnchor) } }
    
    override public var bounds : CGRect { didSet { setNeedsImageUpdate(oldValue != bounds) } }
    
    // MARK: - Image
    
    internal final func gradientImageWithSize(
        size: CGSize,
        colors: [UIColor],
        locations: [CGFloat]?,
        startAnchor: CGPoint,
        endAnchor: CGPoint
        ) -> UIImage?
    {
        guard let gradient = gradient else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let startA = startAnchor == CGPointInfinity ? self.dynamicType.DefaultStartAnchor : startAnchor

        let endA = endAnchor == CGPointInfinity ? self.dynamicType.DefaultEndAnchor : endAnchor
        
        let startPoint = anchor(size, anchor: startA)
        
        let endPoint = anchor(size, anchor: endA)
        
        drawGradient(gradient, withSize: size, start: startPoint, end: endPoint, inContext: context, options: [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private var needsImageUpdate = true
    
    private func setNeedsImageUpdate(needed: Bool = true)
    {
        if needed { needsImageUpdate = true; setNeedsLayout() }
    }
    
    // MARK: - CGGradient
    
    private var gradient : CGGradient?
    
    private func createCGGradient(colors:[UIColor], locations: [CGFloat]?) -> CGGradient?
    {
        let cgColors = colors.map({ $0.CGColor })
        
        if let locations = locations
        {
            return CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), cgColors, locations)
        }
        else
        {
            return CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), cgColors, nil)
        }
    }
    
    internal func drawGradient(gradient: CGGradient, withSize size: CGSize, start: CGPoint, end: CGPoint, inContext context: CGContext, options: CGGradientDrawingOptions)
    {
        debugPrint("Override drawGradient")
    }
    
    private var needsGradientUpdate = true
    
    private func setNeedsGradientUpdate(needed: Bool = true)
    {
        if needed
        {
            needsGradientUpdate = true
            setNeedsImageUpdate()
        }
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if needsGradientUpdate
        {
            needsGradientUpdate = false
            
            gradient = createCGGradient(colors, locations: nil)
        }
        
        if needsImageUpdate
        {
            needsImageUpdate = false
            
            layer.contents = gradientImageWithSize(bounds.size, colors: colors, locations: nil, startAnchor: startAnchor ?? self.dynamicType.DefaultStartAnchor, endAnchor: endAnchor ?? self.dynamicType.DefaultEndAnchor)?.CGImage
        }
    }
    
    // MARK: - Interface Builder

    public override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: 100, height: 100)
    }
}
