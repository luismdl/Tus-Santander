//
//  LineasTableViewCell.swift
//  Tus Santander
//
//  Created by Luis Martin on 14/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import UIKit

class LineasTableViewCell: UITableViewCell {
    //MARK: Properties

    
    @IBOutlet weak var numeroLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
