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
    public struct ColorStop
    {
        var color : UIColor
        var location : Float
    }
    
    let colorStops : Array<ColorStop>
    
    init<C:Collection>(colorStops: C) where C.Iterator.Element == ColorStop
    {
        self.colorStops = colorStops.sorted { $0.location < $1.location }
    }
    
    convenience init?(colors: [UIColor])
    {
        guard colors.count > 1 else { return nil }
        
        let locations = Float(colors.count - 1)
        
        let colorStops = colors.enumerated().map {
            ColorStop(color: $1, location: Float($0) / locations)
        }
        
        self.init(colorStops: colorStops)
    }
    
    var cgGradient : CGGradient?
    {
        let cgColors = colorStops.map { $0.color.cgColor }
        
        let locations = colorStops.map { CGFloat($0.location) }
        
        return CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: cgColors as CFArray,
            locations: locations)
    }
    
    open func imageWithRadialGradient(_ size: CGSize,
                                      startAnchor: CGPoint = CGPoint(x: 0.5, y: 0.5),
                                      endAnchor: CGPoint = CGPoint(x: 0.5, y: 0.5)
        ) -> UIImage?
    {
        guard let cgGradient = self.cgGradient else { return nil }
        
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
        guard let cgGradient = self.cgGradient else { return nil }
        
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
    return lhs.colorStops.map({$0.color}) == rhs.colorStops.map({$0.color}) &&
    lhs.colorStops.map({$0.location}) == rhs.colorStops.map({$0.location})
}

// MARK: - CustomDebugStringConvertible

extension Gradient : CustomDebugStringConvertible
{
    public var debugDescription : String { return "\(type(of: self)): colorStopss: \(colorStops.map({ "\($0.location) : \($0.color)"}))" }
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


