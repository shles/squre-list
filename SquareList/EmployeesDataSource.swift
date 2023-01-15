//
//  EmployeesDataSource.swift
//  SquareList
//
//  Created by Артeмий Шлесберг on 14.01.2023.
//

import Foundation
import Combine

//public protocol EmployeesDataSourceProtocol {
//    func fetch() -> any Publisher<EmployeeData, Error>
//}

public class EmployeesDataSource {
    
    public enum URLConfiguraiton: String {
        case normal = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
        case malformed = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
        case empty = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
    }
    
    private let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private var isIteratingStates: Bool
    
    var url: URLConfiguraiton
    
    init(url: EmployeesDataSource.URLConfiguraiton, isIteratingStates: Bool = false) {
        self.url = url
        self.isIteratingStates = isIteratingStates
    }
    
    func fetch() -> any Publisher<EmployeeData, Error> {
        
        if isIteratingStates {
            switch url {
            case .normal:
                url = .malformed
            case .malformed:
                url = .empty
            case .empty:
                url = .normal
            }
        }
        
        let fetchCancellable = URLSession.shared.dataTaskPublisher(for: URL(string: url.rawValue)!)
                    .map { $0.data }
                    .decode(type: EmployeeData.self, decoder: decoder)
        return fetchCancellable
    }
}
