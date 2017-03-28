//
//  GradientButton.swift
//  Gradient
//
//  Created by Christian Otkjær on 28/03/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit

@IBDesignable
open class GradientButton: UIButton {

    /// The start-color for the Gardient
    @IBInspectable
    open var startColor: UIColor = .white
        {
        didSet{
            setupGradient()
        }
    }
    
    /// The start-point for the Gardient
    @IBInspectable
    open var gradientStartPoint: CGPoint
        {
        set { gradientLayer.startPoint = newValue }
        get { return gradientLayer.startPoint }
    }

    /// The end-color for the Gardient
    @IBInspectable
    open var endColor: UIColor = .black
        {
        didSet{
            setupGradient()
        }
    }
    
    /// The end-point for the Gardient
    @IBInspectable
    open var gradientEndPoint: CGPoint
        {
        set { gradientLayer.endPoint = newValue }
        get { return gradientLayer.endPoint }
    }
    
    func setupGradient()
    {
        let colors = [startColor.cgColor, endColor.cgColor]
        
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        updateGradient()
        
        setNeedsDisplay()
    }
    
    func updateGradient(forSize: CGSize? = nil)
    {
        var size = forSize ?? bounds.size
        
        size.height = max(size.height, bounds.height)
        
        size.width += imageEdgeInsets.left + imageEdgeInsets.right
        size.height += imageEdgeInsets.top + imageEdgeInsets.bottom
        
        let origin = CGPoint(x: -imageEdgeInsets.left, y: -imageEdgeInsets.top)
        
        gradientLayer.frame = CGRect(origin: origin, size: size)
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        updateGradient()
    }
    
    let gradientLayer = CAGradientLayer()
    
    // MARK: - Init
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override open func awakeFromNib()
    {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup()
    {
        setupGradient()
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
