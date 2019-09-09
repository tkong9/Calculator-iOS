//
//  CalculationData.swift
//  Beautiful Calculator
//
//  Created by TAEWON KONG on 9/1/19.
//  Copyright © 2019 TAEWON KONG. All rights reserved.
//

import Foundation
import RealmSwift

class CalculationHistory: Object {
    @objc dynamic var calculation: String = ""
}
