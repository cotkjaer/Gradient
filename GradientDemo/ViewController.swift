//
//  ViewController.swift
//  GradientDemo
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    
    @IBAction func resize()
    {
        view.layoutIfNeeded()
        height.constant *= 0.9
        width.constant *= 1.1
        UIView.animateWithDuration(0.25)
            {
                self.view.layoutIfNeeded()
        }
    }
}

