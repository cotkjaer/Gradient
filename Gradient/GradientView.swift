//
//  LinearGradientView.swift
//  Gradient
//
//  Created by Christian Otkjær on 03/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

@IBDesignable
open class GradientView: UIView
{
    // MARK: - Colors
    
    @IBInspectable
    open var startColor : UIColor = UIColor(white: 1, alpha: 1) { didSet { setNeedsGradientUpdate(oldValue != startColor) } }
    
    @IBInspectable
    open var endColor : UIColor = UIColor(white: 1, alpha: 0) { didSet { setNeedsGradientUpdate(oldValue != endColor) } }
    
    open var otherColors = Array<UIColor>() { didSet { setNeedsGradientUpdate(oldValue != otherColors) } }
    
    open var colors : [UIColor] { return [startColor] + otherColors + [endColor] }
    
    // MARK: - Anchors

    internal class var DefaultStartAnchor : CGPoint { return CGPoint(x: 0, y: 0) }
    
    @IBInspectable
    open var startAnchor : CGPoint = CGPointInfinity
        
        { didSet { setNeedsImageUpdate(oldValue != startAnchor) } }

    internal class var DefaultEndAnchor : CGPoint { return CGPoint(x: 0, y: 0) }

    @IBInspectable
    open var endAnchor : CGPoint = CGPointInfinity
        { didSet { setNeedsImageUpdate(oldValue != endAnchor) } }
    
    override open var bounds : CGRect { didSet { setNeedsImageUpdate(oldValue != bounds) } }
    
    // MARK: - Image
    
    internal final func gradientImageWithSize(
        _ size: CGSize,
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
        
        let startA = startAnchor == CGPointInfinity ? type(of: self).DefaultStartAnchor : startAnchor

        let endA = endAnchor == CGPointInfinity ? type(of: self).DefaultEndAnchor : endAnchor
        
        let startPoint = anchor(size, anchor: startA)
        
        let endPoint = anchor(size, anchor: endA)
        
        drawGradient(gradient, withSize: size, start: startPoint, end: endPoint, inContext: context, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    fileprivate var needsImageUpdate = true
    
    fileprivate func setNeedsImageUpdate(_ needed: Bool = true)
    {
        if needed { needsImageUpdate = true; setNeedsLayout() }
    }
    
    // MARK: - CGGradient
    
    fileprivate var gradient : CGGradient?
    
    fileprivate func createCGGradient(_ colors:[UIColor], locations: [CGFloat]?) -> CGGradient?
    {
        let cgColors = colors.map({ $0.cgColor })
        
        if let locations = locations
        {
            return CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors as CFArray, locations: locations)
        }
        else
        {
            return CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors as CFArray, locations: nil)
        }
    }
    
    internal func drawGradient(_ gradient: CGGradient, withSize size: CGSize, start: CGPoint, end: CGPoint, inContext context: CGContext, options: CGGradientDrawingOptions)
    {
        debugPrint("Override drawGradient")
    }
    
    fileprivate var needsGradientUpdate = true
    
    fileprivate func setNeedsGradientUpdate(_ needed: Bool = true)
    {
        if needed
        {
            needsGradientUpdate = true
            setNeedsImageUpdate()
        }
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews()
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
            
            layer.contents = gradientImageWithSize(bounds.size, colors: colors, locations: nil, startAnchor: startAnchor , endAnchor: endAnchor )?.cgImage
        }
    }
    
    // MARK: - Interface Builder

    open override var intrinsicContentSize : CGSize
    {
        return CGSize(width: 100, height: 100)
    }
}
