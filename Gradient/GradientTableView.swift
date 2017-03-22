//
//  GradientTableView.swift
//  Gradient
//
//  Created by Christian Otkjær on 22/03/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import UIKit

@IBDesignable
open class GradientTableView: UITableView
{
    /// The startColor for the Gardient
    @IBInspectable
    open var startColor: UIColor = .white
        {
        didSet{
            setupGradient()
        }
    }
    
    /// Thet endColor for the Gardient
    @IBInspectable
    open var endColor: UIColor = .black
        {
        didSet{
            setupGradient()
        }
    }
    
    func setupGradient()
    {
        let colors = [startColor.cgColor, endColor.cgColor]
        
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        updateGradient()
        
        setNeedsDisplay()
    }
    
    func updateGradient()
    {
        var size = contentSize
        
        size.height = max(size.height, bounds.height)

        size.width += contentInset.left + contentInset.right
        size.height += contentInset.top + contentInset.bottom

        var origin = CGPoint(x: -contentInset.left, y: -contentInset.top)
        
        if bounces
        {
            size.height += bounds.height / 2
            origin.y -= bounds.height / 4
        }
        
        gradientLayer.frame = CGRect(origin: origin, size: size)
        needsGradientUpdate = false
    }
    
    var needsGradientUpdate: Bool = true
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        if needsGradientUpdate { updateGradient() }
    }
    
    let gradientLayer = CAGradientLayer()
    
    // MARK: - Init

    override init(frame: CGRect, style: UITableViewStyle)
    {
        super.init(frame: frame, style: style)
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
    }
    
    open override var contentSize: CGSize
    {
        didSet { if oldValue != contentSize { needsGradientUpdate = true } }
    }
    
    open override var frame: CGRect
        {
        didSet { if oldValue.size != frame.size { needsGradientUpdate = true } }
    }
}
