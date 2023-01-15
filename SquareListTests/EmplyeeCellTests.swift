//
//  EmplyeeCellTests.swift
//  SquareListTests
//
//  Created by Артeмий Шлесберг on 14.01.2023.
//

import XCTest
import SquareList
import UIKit

class EmployeeCellTests: XCTestCase {
    
    var sut: EmployeeCell!
    var employee: Employee!
    
    override func setUp() {
        super.setUp()
        sut = EmployeeCell()
        employee = Employee(uuid: "1",
                            fullName: "John Doe",
                            team: "Team A",
                            photoUrlSmall: "https://example.com/image.jpg",
                            emailAddress: "johndoe@example.com")
    }
    
    func testConfigure_WithValidEmployee_SetsNameAndTeam() {
        // Act
        sut.configure(employee: employee)
        
        // Assert
        let config = sut.contentConfiguration as? UIListContentConfiguration
        XCTAssertEqual(config?.text, employee.fullName)
        XCTAssertEqual(config?.secondaryText, employee.emailAddress)
    }
    
    func testConfigure_WithCachedImage_SetsImage() {
        // Arrange
        let image = UIImage()
        EmployeeCell.imageCache.setObject(image, forKey: employee.photoUrlSmall as NSString)
        
        // Act
        sut.configure(employee: employee)
        
        // Assert
        let config = sut.contentConfiguration as? UIListContentConfiguration
        XCTAssertEqual(config?.image, image)
    }
    
    func testConfigure_WithInvalidImageURL_SetsPlaceholderImage() {
        // Arrange
        
        employee = Employee(uuid: "1",
                            fullName: "John Doe",
                            team: "Team A",
                            photoUrlSmall: "invalid_url",
                            emailAddress: "johndoe@example.com")
        
        // Act
        sut.configure(employee: employee)
        
        // Assert
        let config = sut.contentConfiguration as? UIListContentConfiguration
        XCTAssertEqual(config?.image, UIImage(systemName: "person.fill"))
    }
}
