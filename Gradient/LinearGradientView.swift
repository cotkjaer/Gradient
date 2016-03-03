//
//  LinearGradientView.swift
//  Gradient
//
//  Created by Christian Otkjær on 03/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

@IBDesignable
public class LinearGradientView: GradientView
{
    // MARK: - Anchors
    
    override internal class var DefaultStartAnchor : CGPoint { return CGPoint(x: 0, y: 0.5) }

    override internal class var DefaultEndAnchor : CGPoint { return CGPoint(x: 1, y: 0.5) }
    
    // MARK: - Draw

    override func drawGradient(gradient: CGGradient, withSize size: CGSize, start: CGPoint, end: CGPoint, inContext context: CGContext, options: CGGradientDrawingOptions)
    {
          CGContextDrawLinearGradient(context, gradient, start, end, options)
    }
}
