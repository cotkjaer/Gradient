//
//  UIView+Color.swift
//  Gradient
//
//  Created by Christian Otkjær on 28/03/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit

// MARK: - Color

extension UIView
{
    func colorAtPoint(point:CGPoint) -> UIColor?
    {
        let pixels = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)

        defer { pixels.deallocate(capacity: 4) }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(data: pixels, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
        
        context.translateBy(x: -point.x, y: -point.y)
        
        layer.render(in: context)
        
        let color = UIColor(red: CGFloat(pixels[0])/255, green: CGFloat(pixels[1])/255, blue: CGFloat(pixels[2])/255, alpha: CGFloat(pixels[3])/255)
        
        return color
    }
}

