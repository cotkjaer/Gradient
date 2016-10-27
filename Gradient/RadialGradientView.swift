//
// RadialGradientView.swift
// Gradient
//
// Created by Christian Otkjær on 02/03/16.
// Copyright © 2016 Christian Otkjær. All rights reserved.
//


@IBDesignable
open class RadialGradientView: GradientView
{
    // MARK: - Anchors
    
    override internal class var DefaultStartAnchor : CGPoint { return CGPoint(x: 0.5, y: 0.5) }
    
    override internal class var DefaultEndAnchor : CGPoint { return CGPoint(x: 0.5, y: 0.5) }
    
    // MARK: - Draw
    
    override func drawGradient(_ gradient: CGGradient, withSize size: CGSize, start: CGPoint, end: CGPoint, inContext context: CGContext, options: CGGradientDrawingOptions)
    {
        let radius = max(max(size.width - end.x, end.x), max(size.height - end.y, end.y))
        
        context.drawRadialGradient(gradient, startCenter: start, startRadius: 0, endCenter: end, endRadius: radius, options: options)
    }
}
