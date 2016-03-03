//
//  Anchor.swift
//  Gradient
//
//  Created by Christian Otkjær on 03/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

internal func anchor(size: CGSize, anchor: CGPoint) -> CGPoint
{
    return CGPoint(
        x: size.width * min(1, max (0, anchor.x)),
        y: size.height * min(1, max(0, anchor.y)))
}

internal func * (size: CGSize, anchor: CGPoint) -> CGPoint
{
    return CGPoint(
        x: size.width * min(1, max (0, anchor.x)),
        y: size.height * min(1, max(0, anchor.y)))
}