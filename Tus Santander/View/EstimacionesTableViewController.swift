//
//  EstimacionesTableViewController.swift
//  Tus Santander
//
//  Created by Luis Martin on 15/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import UIKit

class EstimacionesTableViewController: UITableViewController {
    
    let URL_ESTIMACIONES = "http://datos.santander.es/api/rest/datasets/control_flotas_estimaciones.json?items=2000"
    
    @IBOutlet var estimaciones: UITableView!
    var activity:UIActivityIndicatorView = UIActivityIndicatorView()
    var para = Parada(num: "", nom: "",fav:  false)
    var estima = [Estimacion]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.center = self.tableView.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activity.color=UIColor.black
        
        tableView.addSubview(activity)
        
        activity.startAnimating()
        getJsonEstimacion()
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
        return estima.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EstimacionTableViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EstimacionTableViewCell
            else{
                fatalError("puta mierda")
        }
        let estimacion = estima[indexPath.row]
        
        cell.linea.text=estimacion.linea
        cell.bus1.text=String(estimacion.bus1)
        cell.bus2.text=String(estimacion.bus2)
        
        return cell
    }
    
    func getJsonEstimacion(){
        
        //creating a NSURL
        self.estima = [Estimacion]()
        let url = URL(string: URL_ESTIMACIONES)
        URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error) -> Void in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //getting the avengers tag array from json and converting it to NSArray
                if let estimaArray = jsonObj!.value(forKey: "resources") as? NSArray {
                    //looping through all the elements
                    for estima in estimaArray{
                        
                        //converting the element to a dictionary
                        if let estimaDict = estima as? NSDictionary {
                            //getting the name from the dictionary
                            guard let t1 = estimaDict.value(forKey: "ayto:tiempo1")as? String,
                                let t2 = estimaDict.value(forKey: "ayto:tiempo2")as? String,
                                let parada = estimaDict.value(forKey: "ayto:paradaId")as? String,
                                let date = estimaDict.value(forKey: "dc:modified") as? String,
                                let linea = estimaDict.value(forKey: "ayto:etiqLinea")as? String
                                else{
                                    fatalError("puta mierda")
                            }
                            let dat = dateFormatter.date(from: date)!
                            let now = Date()
                            let calendar = Calendar.current
                            if(calendar.component(.day, from: dat)-calendar.component(.day, from: now)<1 &&
                                calendar.component(.hour, from: dat)-calendar.component(.hour, from: now)<1){
                                if(self.para.numero==parada){
                                    
                                    var t1i = (t1 as NSString).intValue
                                    t1i = t1i/60
                                    var t2i = (t2 as NSString).intValue
                                    t2i = t2i/60
                                    if(t2i != 0){
                                        let e = Estimacion(lin: linea, b1: Int(t1i), b2: Int(t2i))
                                        self.estima += [e]
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async{
                self.estima.sort()
                self.activity.stopAnimating()
                self.tableView.reloadData()
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
