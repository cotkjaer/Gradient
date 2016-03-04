//
//  Gradient.swift
//  Gradient
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

private let GradientDrawingOptions : CGGradientDrawingOptions =
[.DrawsBeforeStartLocation, .DrawsAfterEndLocation]

private let DefaultColors : [UIColor] = [UIColor(white: 1, alpha: 1), UIColor(white: 1, alpha: 0)]

public class Gradient
{
    private let cgGradient : CGGradient?
    
    public let colors : [UIColor]
    public let locations : [CGFloat]
    
    init?(
        colors: [UIColor] = [UIColor(white: 1, alpha: 1), UIColor(white: 1, alpha: 0)],
        locations: [CGFloat]? = nil)
    {
        self.colors = colors
        self.locations = locations ?? (0..<colors.endIndex).map({ CGFloat($0) / CGFloat(colors.endIndex - 1)})
        self.cgGradient = createCGGradient(colors, locations: locations)
        
        guard colors.count > 1 else { return nil }
        guard cgGradient != nil else { return nil }
    }
    
    public func imageWithRadialGradient(size: CGSize,
        startAnchor: CGPoint = CGPoint(x: 0.5, y: 0.5),
        endAnchor: CGPoint = CGPoint(x: 0.5, y: 0.5)
        ) -> UIImage?
    {
        guard let cgGradient = cgGradient else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let startCenter = anchor(size, anchor: startAnchor)
        
        let endCenter = anchor(size, anchor: endAnchor)
        
        let endRadius = max(max(size.width - endCenter.x, endCenter.x), max(size.height - endCenter.y, endCenter.y))
        
        CGContextDrawRadialGradient(context, cgGradient, startCenter, 0, endCenter, endRadius, GradientDrawingOptions)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public func imageWithLinearGradient(
        size: CGSize,
        startAnchor: CGPoint = CGPoint(x: 0, y: 0.5),
        endAnchor: CGPoint = CGPoint(x: 1, y: 0.5)
        ) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let startPoint = anchor(size, anchor: startAnchor)
        
        let endPoint = anchor(size, anchor: endAnchor)
        
        CGContextDrawLinearGradient(context, cgGradient, startPoint, endPoint, GradientDrawingOptions)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

//MARK: - Equatable

extension Gradient : Equatable {}

public func == (lhs: Gradient, rhs:Gradient) -> Bool
{
    return lhs.colors == rhs.colors && lhs.locations == rhs.locations
}

// MARK: - CustomDebugStringConvertible

extension Gradient : CustomDebugStringConvertible
{
    public var colorsDebugDescription: String
        {
            return colors.map({ $0.debugDescription }).joinWithSeparator(",")
    }

    public var locationsDebugDescription: String
        {
            return locations.map({ String(format: "%.3f", $0)}).joinWithSeparator(",")
    }
    
    public var debugDescription : String { return "\(self.dynamicType): colors: \(colorsDebugDescription), locations: \(locationsDebugDescription)" }
}

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


