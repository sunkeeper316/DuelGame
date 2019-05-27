//
//  CardCell.swift
//  DuelGame
//
//  Created by 黃德桑 on 2019/5/25.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var ivImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lbname: UILabel!
    
    @IBOutlet weak var lbcardcount: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
