//
//  ViewModelTests.swift
//  SquareListTests
//
//  Created by Артeмий Шлесберг on 14.01.2023.
//

import XCTest
import SquareList
import Combine

class EmployeesDataSourceMock: EmployeesDataSource {
    var result: Result<EmployeeData, Error>!
    
    internal init(result: Result<EmployeeData, Error>? = nil) {
        self.result = result
        super.init(url: .empty)
    }
    
    override func fetch() -> any Publisher<EmployeeData, Error> {
        return Result.Publisher(result)
            .eraseToAnyPublisher()
    }
}

extension ViewModel.State: Equatable {
    static func ==(lhs: ViewModel.State, rhs: ViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.content(let lContent), .content(let rContent)):
            return lContent == rContent
        case (.error(let lError), .error(let rError)):
            return lError == rError
        default:
            return false
        }
    }
}

class ViewModelTests: XCTestCase {
    
    var sut: ViewModel!
    var dataSource: EmployeesDataSourceMock!
    
    override func setUp() {
        super.setUp()
        dataSource = EmployeesDataSourceMock()
        sut = ViewModel(dataSource: dataSource)
    }
    
    func testReload_ReturnsContent() {
        // Arrange
        dataSource.result = .success(EmployeeData(employees: [Employee(uuid: "", fullName: "", team: "team", photoUrlSmall: "", emailAddress: "")]))
        
        // Act
        sut.reload()
        
        // Assert
        
        XCTAssertEqual(sut.state, .content(["team": [Employee(uuid: "", fullName: "", team: "team", photoUrlSmall: "", emailAddress: "")]]) )
    }
    
    func testReload_ReturnsEmpty() {
        // Arrange
        dataSource.result = .success(EmployeeData(employees: []))
        
        // Act
        sut.reload()
        
        // Assert
        XCTAssertEqual(sut.state, .error("No emplyees") )
    }
    
    func testReload_ReturnsError() {
        // Arrange
        dataSource.result = .failure(NSError(domain: "", code: 0, userInfo: nil))
        
        // Act
        sut.reload()
        
        // Assert
        XCTAssertEqual(sut.state, .error("The operation couldn’t be completed. ( error 0.)"))
    }
}
