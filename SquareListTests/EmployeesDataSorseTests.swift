//
//  EmployeesDataSorseTests.swift
//  SquareListTests
//
//  Created by Артeмий Шлесберг on 14.01.2023.
//

import XCTest
import SquareList

class EmployeesDataSourceTests: XCTestCase {
    
    var sut: EmployeesDataSource!
    
    override func setUp() {
        super.setUp()
    }
    
    func testConfigurationURL_normal() {
        XCTAssertNotNil(URL(string: EmployeesDataSource.URLConfiguraiton.normal.rawValue))
    }
    
    func testConfigurationURL_empty() {
        XCTAssertNotNil(URL(string: EmployeesDataSource.URLConfiguraiton.empty.rawValue))
    }
    
    func testConfigurationURL_malformed() {
        XCTAssertNotNil(URL(string: EmployeesDataSource.URLConfiguraiton.malformed.rawValue))
    }
    
    func testFetch_NormalURL_ReturnsSuccess() {
        // Arrange
        sut = EmployeesDataSource(url: .normal)
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch Employees")
        let cancellable = sut.fetch()
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure:
                    XCTFail("Fetching employees failed")
                case .finished:
                    expectation.fulfill()
                }
            }, receiveValue: { employeesData in
                XCTAssert(employeesData.employees.count > 0, "No employees fetched")
            })
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testFetch_MalformedURL_ReturnsError() {
        // Arrange
        sut = EmployeesDataSource(url: .malformed)
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch Employees")
        let cancellable = sut.fetch()
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Fetching employees should have failed")
                }
            }, receiveValue: { _ in
                XCTFail("Fetching employees should have failed")
            })
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
        
    func testFetch_EmptyURL_ReturnsError() {
        // Arrange
        sut = EmployeesDataSource(url: .empty)

        // Act
        let expectation = XCTestExpectation(description: "Fetch Employees")
        let cancellable = sut.fetch()
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(_):
                    XCTFail("Fetching employees failed")
                case .finished:
                    expectation.fulfill()
                }
            }, receiveValue: { employeesData in
                XCTAssert(employeesData.employees.count == 0, "No employees fetched")
            })
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(cancellable)
    }
}
