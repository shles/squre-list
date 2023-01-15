//
//  EmployeesDataTests.swift
//  SquareListTests
//
//  Created by Артeмий Шлесберг on 14.01.2023.
//

import Foundation
import XCTest
import SquareList

class EmployeeDataTests: XCTestCase {
    func testEmployeesByTeam() {
        let employee1 = Employee(uuid: "123", fullName: "John Doe", team: "Team A", photoUrlSmall: "www.photo1.com", emailAddress: "john.doe@email.com")
        let employee2 = Employee(uuid: "456", fullName: "Jane Smith", team: "Team B", photoUrlSmall: "www.photo2.com", emailAddress: "jane.smith@email.com")
        let employee3 = Employee(uuid: "789", fullName: "Mike Johnson", team: "Team A", photoUrlSmall: "www.photo3.com", emailAddress: "mike.johnson@email.com")
        let employeeData = EmployeeData(employees: [employee1, employee2, employee3])
        
        let expectedResult = [
            "Team A": [employee1, employee3],
            "Team B": [employee2]
        ]
        
        XCTAssertEqual(employeeData.employeesByTeam, expectedResult)
    }
}

class EmployeeTests: XCTestCase {
    func testEmployeeInitialization() {
        let employee = Employee(uuid: "123", fullName: "John Doe", team: "Team A", photoUrlSmall: "www.photo.com", emailAddress: "john.doe@email.com")
        
        XCTAssertEqual(employee.uuid, "123")
        XCTAssertEqual(employee.fullName, "John Doe")
        XCTAssertEqual(employee.team, "Team A")
        XCTAssertEqual(employee.photoUrlSmall, "www.photo.com")
        XCTAssertEqual(employee.emailAddress, "john.doe@email.com")
    }
}
