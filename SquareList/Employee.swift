//
//  Employee.swift
//  SquareList
//
//  Created by Артeмий Шлесберг on 13.01.2023.
//

import Foundation

struct EmployeeData: Codable {
    
    init(employees: [Employee]) {
        self.employees = employees
    }
    
    let employees: [Employee]
    
    var employeesByTeam: [String: [Employee]] {
        let teams = Set(employees.map{$0.team})
        var result = [String: [Employee]]()
        for team in teams.sorted() {
            let employeesByTeam = employees
                .filter { $0.team == team }
                .sorted { $0.fullName < $1.fullName }
            result[team] = employeesByTeam
        }
        return result
    }
}

struct Employee: Codable, Hashable {
    
    public init(uuid: String, fullName: String, team: String, photoUrlSmall: String, emailAddress: String) {
        self.uuid = uuid
        self.fullName = fullName
        self.team = team
        self.photoUrlSmall = photoUrlSmall
        self.emailAddress = emailAddress
    }
    
    public let uuid: String
    public let fullName: String
    public let team: String
    public let photoUrlSmall: String
    public let emailAddress: String
}
