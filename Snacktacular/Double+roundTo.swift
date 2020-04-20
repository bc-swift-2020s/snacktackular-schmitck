//
//  Double+roundTo.swift
//  Snacktacular
//
//  Created by Cooper Schmitz on 4/17/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation

//rounds any double to "places" places, example: if value is 3.275, value.roundTo(places: 1) = 3.3

extension Double {
  func roundTo(places: Int) -> Double {
    let tenToPower = pow(10.0, Double((places >= 0 ? places : 0)))
    let roundedValue = (self * tenToPower).rounded() / tenToPower
    return roundedValue
  }
}
