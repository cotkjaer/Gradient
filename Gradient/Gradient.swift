//
//  Gradient.swift
//  Gradient
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

private let GradientDrawingOptions : CGGradientDrawingOptions = [.drawsBeforeStartLocation, .drawsAfterEndLocation]

private let DefaultColors : [UIColor] = [UIColor(white: 1, alpha: 1), UIColor(white: 1, alpha: 0)]

open class Gradient
{
    fileprivate let cgGradient : CGGradient?
    
    open let colors : [UIColor]
    open let locations : [CGFloat]
    
    public init?(
        colors: [UIColor] = [UIColor(white: 1, alpha: 1), UIColor(white: 1, alpha: 0)],
        locations: [CGFloat]? = nil)
    {
        self.colors = colors
        self.locations = locations ?? (colors.indices.suffix(from: 0)).map({ CGFloat($0) / CGFloat(colors.endIndex - 1)})
        self.cgGradient = createCGGradient(colors, locations: locations)
        
        guard colors.count > 1 else { return nil }
        guard cgGradient != nil else { return nil }
    }
    
    open func imageWithRadialGradient(_ size: CGSize,
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
        
        context.drawRadialGradient(
            cgGradient,
            startCenter: startCenter,
            startRadius: 0,
            endCenter: endCenter,
            endRadius: endRadius,
            options: GradientDrawingOptions)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    open func imageWithLinearGradient(
        _ size: CGSize,
        startAnchor: CGPoint = CGPoint(x: 0, y: 0.5),
        endAnchor: CGPoint = CGPoint(x: 1, y: 0.5)
        ) -> UIImage?
    {
        guard let cgGradient = cgGradient else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let startPoint = anchor(size, anchor: startAnchor)
        
        let endPoint = anchor(size, anchor: endAnchor)
        
        context.drawLinearGradient(cgGradient, start: startPoint, end: endPoint, options: GradientDrawingOptions)
        
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
        return colors.map({ $0.debugDescription }).joined(separator: ",")
    }
    
    public var locationsDebugDescription: String
    {
        return locations.map({ String(format: "%.3f", $0)}).joined(separator: ",")
    }
    
    public var debugDescription : String { return "\(type(of: self)): colors: \(colorsDebugDescription), locations: \(locationsDebugDescription)" }
}

private func createCGGradient(_ colors:[UIColor], locations: [CGFloat]?) -> CGGradient?
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


