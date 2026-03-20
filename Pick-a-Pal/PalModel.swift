//
//  PalModel.swift
//  Pick-a-Pal
//
//  Created by Felipe Eduardo Campelo Ferreira Osorio on 20/03/26.
//

import Foundation
import SwiftData

@Model
class PalModel {
    
    // MARK: - Properties
    
    var name: String
    
    // MARK: - Init
    
    init(name: String) {
        self.name = name
    }
}
