//
//  NewsTableViewCell.swift
//  News Lite
//
//  Created by Neel Nishant on 06/02/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var widthOfImage: NSLayoutConstraint!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!
    
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 10.0
    }
}
