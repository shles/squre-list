//
//  Employee.swift
//  SquareList
//
//  Created by Артeмий Шлесберг on 13.01.2023.
//

import Foundation

struct EmployeeData: Codable {
    let employees: [Employee]
}

struct Employee: Codable, Hashable {
    let uuid: String
    let fullName: String
    let team: String
    let photoUrlSmall: String
}
