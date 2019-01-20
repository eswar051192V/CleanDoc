//
//  UIScrollViewExtension.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 13/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIScrollViewExt: UIScrollView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var _cSize: CGSize!
    @IBInspectable
    var cSize: CGSize {
        get {
            if self._cSize == nil {
                self._cSize = self.superview?.frame.size
            }
            return self._cSize ?? UIScreen.main.bounds.size
        }
        set {
            self.contentSize = newValue
            self._cSize = newValue
        }
    }
}
