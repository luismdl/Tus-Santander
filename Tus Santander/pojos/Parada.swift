//
//  Parada.swift
//  Tus Santander
//
//  Created by Luis Martin on 15/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import Foundation
import os.log

class Parada: NSObject, Comparable, NSCoding {
    
    //MARK: Properties
    var numero: String
    var nombre: String
    var favorito: Bool
    struct PropertyKey {
        static let numero = "number"
        static let nombre = "nombre"
        static let fav = "favoritos"
    }
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("paradas")
    
    
    init(num:String, nom:String, fav:Bool) {
        self.numero = num
        self.nombre = nom
        self.favorito = fav
    }
    
    
    
    static func <(lhs: Parada, rhs: Parada) -> Bool {
        return lhs.numero<rhs.numero
    }
    
    static func ==(lhs: Parada, rhs: Parada) -> Bool {
        return lhs.numero==rhs.numero
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(numero, forKey: PropertyKey.numero)
        aCoder.encode(nombre, forKey: PropertyKey.nombre)
        aCoder.encode(favorito, forKey: PropertyKey.fav)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let numero = aDecoder.decodeObject(forKey: PropertyKey.numero) as? String else {
                os_log("Unable to decode the num for a paradas object.", log: OSLog.default, type: .debug)
                return nil
        }
        guard let nombre = aDecoder.decodeObject(forKey: PropertyKey.nombre) as? String else {
            os_log("Unable to decode the name for a paradas object.", log: OSLog.default, type: .debug)
            return nil
        }
        let fav = aDecoder.decodeBool(forKey: PropertyKey.fav)

        self.init(num: numero, nom: nombre, fav: fav)
        
    }
}
