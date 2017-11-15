//
//  Estimacion.swift
//  Tus Santander
//
//  Created by Luis Martin on 15/11/17.
//  Copyright © 2017 Luis Martin. All rights reserved.
//

import Foundation

class Estimacion: Comparable{
    static func <(lhs: Estimacion, rhs: Estimacion) -> Bool {
        return lhs.bus1<rhs.bus1
    }
    
    static func ==(lhs: Estimacion, rhs: Estimacion) -> Bool {
        return lhs.bus1==rhs.bus1
    }
    
    
    //MARK: Properties
    var linea: String
    var bus1: Int
    var bus2: Int
    
    init(lin:String, b1:Int,b2:Int) {
        self.linea=lin
        self.bus1 = b1
        self.bus2 = b2
    }

}
