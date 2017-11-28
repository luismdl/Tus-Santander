//
//  LineasTableViewController.swift
//  Tus Santander
//
//  Created by Luis Martin on 14/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import UIKit
import os.log

class LineasTableViewController: UITableViewController, UITabBarControllerDelegate{
    
    //MARK: Properties
    
    @IBOutlet var tabla: UITableView!
    let URL_LINEAS = "http://datos.santander.es/api/rest/datasets/lineas_bus.json"
    let URL_PARADAS = "http://datos.santander.es/api/rest/datasets/paradas_bus.json?items=500"
    let URL_PARADASLINEAS = "http://datos.santander.es/api/rest/datasets/lineas_bus_paradas.json?items=3000"
    
    var lineas = [Linea]()
    static var paradas = [Parada]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       if let guardado = loadLineas() {
            lineas += guardado
            os_log("lineas cargadas de data.", log: OSLog.default, type: .debug)
            if let guarda2 = loadParadas() {
                LineasTableViewController.paradas += guarda2
                os_log("paradas cargadas de data.", log: OSLog.default, type: .debug)
            }else{
                getJsonParadasFromUrl()
            }
        }
        else {
            getJsonLineasFromUrl()
        
       }
        getJsonParadasFromUrl()
        
        
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
         self.lineas.sort()
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
    
    func getJsonLineasFromUrl(){
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
            DispatchQueue.main.async{
                self.lineas.sort()
                self.tabla.reloadData()
            }
        }).resume()
        self.getJsonParadasFromUrl()
    }
    
    func getJsonParadasFromUrl(){
        //creating a NSURL
        let url = URL(string: URL_PARADAS)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //getting the avengers tag array from json and converting it to NSArray
                if let paradasArray = jsonObj!.value(forKey: "resources") as? NSArray {
                    //looping through all the elements
                    for parada in paradasArray{
                        
                        //converting the element to a dictionary
                        if let paradaDict = parada as? NSDictionary {
                            //getting the name from the dictionary
                            guard let num = paradaDict.value(forKey: "ayto:numero") as? String,
                                let nom = paradaDict.value(forKey: "ayto:parada")as? String
                                else{
                                    fatalError("puta mierda")
                            }
                            LineasTableViewController.paradas += [Parada(num: num,nom: nom,fav: false)]
                        }
                    }
                }
            }
            DispatchQueue.main.async{
                LineasTableViewController.paradas.sort()
                self.getJsonParadabyLineaFromUrl()
            }
        }).resume()
    }
    
    func getJsonParadabyLineaFromUrl(){
        
            //creating a NSURL
            let url = URL(string: URL_PARADASLINEAS)
            URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error) -> Void in
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    //getting the avengers tag array from json and converting it to NSArray
                    if let paradasArray = jsonObj!.value(forKey: "resources") as? NSArray {
                        //looping through all the elements
                        for parada in paradasArray{
                            
                            //converting the element to a dictionary
                            if let paradaDict = parada as? NSDictionary {
                                //getting the name from the dictionary
                                guard let par = paradaDict.value(forKey: "ayto:parada")as? String,
                                    let lin = paradaDict.value(forKey: "ayto:linea")as? String
                                    else{
                                        fatalError("puta mierda")
                                }
                                if let i = self.lineas.index(where: { $0.identificador == lin }) {
                                    self.lineas[i].paradas += [par]
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async{
                    LineasTableViewController.saveParadas()
                    self.saveLineas()
                }
            }).resume()
    }
    
    private func saveLineas() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(lineas, toFile: Linea.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("lineas successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadLineas() -> [Linea]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Linea.ArchiveURL.path) as? [Linea]
    }
    
    class func saveParadas() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(paradas, toFile: Parada.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("paradas successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadParadas() -> [Parada]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Parada.ArchiveURL.path) as? [Parada]
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "muestraParadas":
            
            guard let paradaController = segue.destination as? ParadasTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let linea = sender as? LineasTableViewCell else {
                fatalError("Unexpected sender:")
            }
            
            guard let indexPath = tableView.indexPath(for: linea) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let Slinea = lineas[indexPath.row]
            let parad=getparadas(l: Slinea)
            paradaController.paradas=parad
            
        case "muestraFav":
            
            guard let paradaController = segue.destination as? ParadasTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let parad=getFavs()
            paradaController.paradas=parad
            
        default:
            fatalError("Unexpected Segue Identifier;")
        }
        
    }
    
    func getparadas(l: Linea) -> [Parada]{
        var para = [Parada]()
        if(l.paradas.count==0){
            return LineasTableViewController.paradas
        }
        
        l.paradas.forEach { par in
            if let i = LineasTableViewController.paradas.index(where: { $0.numero == par }) {
                para += [LineasTableViewController.paradas[i]]
            }
        }
        return para
    }
    
    func getFavs() -> [Parada]{
        var para = [Parada]()
        LineasTableViewController.paradas.forEach { par in
            if (par.favorito) {
                para += [par]
            }
        }
        return para
    }
    

}
