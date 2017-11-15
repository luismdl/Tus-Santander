//
//  File.swift
//  Tus Santander
//
//  Created by Luis Martin on 14/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import Foundation

class Linea: Comparable{
    
    static func <(lhs: Linea, rhs: Linea) -> Bool {
        return lhs.identificador<rhs.identificador
    }
    
    static func ==(lhs: Linea, rhs: Linea) -> Bool {
        return lhs.identificador==rhs.identificador
    }
    
    var numero: String
    var nombre: String
    var identificador: Int
    
    
    init(num:String, nom:String, id:Int) {
        self.numero = num
        self.nombre = nom
        self.identificador = id
    }
}
