//
//  RubiTableViewCell.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/27.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class RubiTableViewCell: UITableViewCell {
    @IBOutlet weak var rubiLabel: UILabel!
    @IBOutlet weak var kanjiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
