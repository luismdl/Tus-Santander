//
//  ParadasTableViewController.swift
//  Tus Santander
//
//  Created by Luis Martin on 15/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import UIKit
import os.log

class ParadasTableViewController: UITableViewController {

    
    @IBOutlet var paradasT: UITableView!
    
    var paradas = [Parada]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(paradas.count>0){
            tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paradas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ParadaTableViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ParadaTableViewCell
            else{
                fatalError("puta mierda")
        }
        let parada = paradas[indexPath.row]
        
        cell.numero.text = parada.numero
        cell.nombre.text = parada.nombre
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "estimame":
            guard let estimacionesController = segue.destination as? EstimacionesTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let parada = sender as? ParadaTableViewCell else {
                fatalError("Unexpected sender:")
            }
            
            guard let indexPath = tableView.indexPath(for: parada) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let ada = paradas[indexPath.row]
            estimacionesController.para=ada
            
        default:
            fatalError("Unexpected Segue Identifier;")
        }
    }
    

}
