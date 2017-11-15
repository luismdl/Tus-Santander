//
//  ParadaTableViewCell.swift
//  Tus Santander
//
//  Created by Luis Martin on 15/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import UIKit

class ParadaTableViewCell: UITableViewCell {
    //MARK: Properties
    
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var nombre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
