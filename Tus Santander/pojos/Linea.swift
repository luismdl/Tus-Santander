//
//  File.swift
//  Tus Santander
//
//  Created by Luis Martin on 14/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import Foundation
import os.log

class Linea: NSObject, Comparable, NSCoding {
    
    //MARK: Properties
    var numero: String
    var nombre: String
    var identificador: String
    var intid: Int
    var paradas = [String]()
    struct PropertyKey {
        static let numero = "number"
        static let nombre = "nombre"
        static let identificador = "id"
    }
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("lineas")

    
    init(num:String, nom:String, id:String) {
        self.numero = num
        self.nombre = nom
        self.identificador = id
        self.intid = (id as NSString).integerValue
    }
    
    
    
    static func <(lhs: Linea, rhs: Linea) -> Bool {
        return Int(lhs.intid)<Int(rhs.intid)
    }
    
    static func ==(lhs: Linea, rhs: Linea) -> Bool {
        return Int(lhs.intid)==Int(rhs.intid)
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(numero, forKey: PropertyKey.numero)
        aCoder.encode(nombre, forKey: PropertyKey.nombre)
        aCoder.encode(identificador, forKey: PropertyKey.identificador)
        aCoder.encode(paradas, forKey: "Arr")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let numero = aDecoder.decodeObject(forKey: PropertyKey.numero) as? String,
            let nombre = aDecoder.decodeObject(forKey: PropertyKey.nombre) as? String,
            let id = aDecoder.decodeObject(forKey: PropertyKey.identificador) as? String else {
                os_log("Unable to decode the name for a linea object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        self.init(num: numero, nom: nombre, id: id)
        self.paradas = (aDecoder.decodeObject(forKey:"Arr") as? [String])!
    }
}
