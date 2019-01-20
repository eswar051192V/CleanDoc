//
//  UIButtonExtension.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 13/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIButtonExtension: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.setNeedsDisplay()
        }
    }
    
    var _shadowRadius: CGFloat = 0.0
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return self._shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            self._shadowRadius = newValue
            self.setNeedsDisplay()
        }
    }
    
    var _shadowOpacity: Float = 0.0
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return self._shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            self._shadowOpacity = newValue
            self.setNeedsDisplay()
        }
    }
    
    var _shadowOffset: CGSize = CGSize(width: 0, height: 0)
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return self._shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            self._shadowOffset = newValue
            self.setNeedsDisplay()
        }
    }
    
    var _shadowColor: UIColor?
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return self._shadowColor
        }
        set {
            self._shadowColor = newValue
            layer.shadowColor = newValue?.cgColor
            self.setNeedsDisplay()
        }
    }
}
