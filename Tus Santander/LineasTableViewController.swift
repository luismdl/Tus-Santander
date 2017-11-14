//
//  LineasTableViewController.swift
//  Tus Santander
//
//  Created by Luis Martin on 14/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import UIKit

class LineasTableViewController: UITableViewController {
    
    //MARK: Properties
    
     let URL_LINEAS = "http://datos.santander.es/api/rest/datasets/lineas_bus.json";
    
    var lineas = [Linea]()
    private func loadSample(){
        let l1 = Linea(num: "1",nom: "uno",id: "1")
        let l2 = Linea(num: "2",nom: "dos",id: "2")
        let l3 = Linea(num: "3",nom: "tres",id: "2")
        let l4 = Linea(num: "4",nom: "cuatro",id: "4")
        
        lineas += [l1,l2,l3,l4]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getJsonFromUrl()
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
        return lineas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LineasTableViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?LineasTableViewCell
            else{
                fatalError("puta mierda")
        }
        let linea = lineas[indexPath.row]
        
        cell.numeroLabel.text = linea.numero
        cell.nombreLabel.text = linea.nombre

        return cell
    }
    
    func getJsonFromUrl(){
        //creating a NSURL
        let url = URL(string: URL_LINEAS)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //getting the avengers tag array from json and converting it to NSArray
                if let lineasArray = jsonObj!.value(forKey: "resources") as? NSArray {
                    //looping through all the elements
                    for linea in lineasArray{
                        
                        //converting the element to a dictionary
                        if let lineaDict = linea as? NSDictionary {
                            //getting the name from the dictionary
                            guard let num = lineaDict.value(forKey: "ayto:numero") as? String,
                            let nom = lineaDict.value(forKey: "dc:name")as? String,
                            let id = lineaDict.value(forKey: "dc:identifier")as? String
                                else{
                                    fatalError("puta mierda")
                            }
                            
                            self.lineas += [Linea(num: num,nom: nom,id: id)]
                        }
                    }
                }
            }
        }).resume()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
