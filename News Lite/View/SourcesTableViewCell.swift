//
//  SourcesTableViewCell.swift
//  News Lite
//
//  Created by Neel Nishant on 06/02/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit

class SourcesTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }

}
