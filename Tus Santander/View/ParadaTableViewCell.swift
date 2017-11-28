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
    
    @IBOutlet weak var favo: UIButton!
    
    var parada = Parada(num: "", nom: "", fav: false)
    let filledStar = UIImage(named: "Rellena")
    let emptyStar = UIImage(named:"Vacio")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(parada.favorito){
            favo.setImage(filledStar, for: .normal)
        }else{
            favo.setImage(emptyStar, for: .normal)
        }
        LineasTableViewController.saveParadas()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeTap(sender:UIButton){
        if sender == self.favo{
            parada.favorito = !parada.favorito
            
            if(parada.favorito){
                favo.setImage(filledStar, for: .normal)
            }else{
                favo.setImage(emptyStar, for: .normal)
            }
            
        }
    }
}
