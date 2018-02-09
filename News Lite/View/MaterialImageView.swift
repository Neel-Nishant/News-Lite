//
//  MaterialImageView.swift
//  News Lite
//
//  Created by Neel Nishant on 07/02/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit

class MaterialImageView: UIImageView {

    let SHADOW_COLOR: CGFloat = 157.0 / 255.0
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 20.0
        layer.masksToBounds = true
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
