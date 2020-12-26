//
//  UIViewCircular.swift
//  My Trane Rewards
//
//  Created by Pixiders on 03/12/2019.
//  Copyright © 2019 Pixiders. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewCircular: UIView {
    
    @IBInspectable var isCircular: Bool = true {
        didSet {
            updateView()
        }
    }
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    
    
    func updateView() {
        if isCircular{
            self.layer.cornerRadius = self.frame.height / 2
        }
    }
    
    
}
