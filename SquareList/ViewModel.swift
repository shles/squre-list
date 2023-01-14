//
//  ViewModel.swift
//  SquareList
//
//  Created by Артeмий Шлесберг on 13.01.2023.
//

import Foundation
import Combine

class ViewModel {
    
    enum State {
        case content([Employee])
        case error(String)
        case loading
    }
    
    @Published var state: State = .error("")
    
    func reload() {
        
//        state = .content([
//            Employee(uuid: "0", fullName: "John Dow", team: "Apple", photoUrlSmall: ""),
//            Employee(uuid: "1", fullName: "John Appleseed", team: "Apple", photoUrlSmall: ""),
//            Employee(uuid: "2", fullName: "Tim Cook", team: "Apple", photoUrlSmall: "")
//        ])
//
//        return
        
        fetch { [weak self] employes, error in
            guard let employes = employes else {
                if let error = error {
                    self?.state = .error(error.localizedDescription)
                } else {
                    self?.state = .error("Invalid response")
                }
                return
            }

            if employes.isEmpty {
                self?.state = .error("No emplyees")
            } else {
                self?.state = .content(employes)
            }
        }
    }
    
    private func fetch(completion: @escaping ([Employee]?, Error?) -> Void) {
        guard let url = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json") else {
            completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "Invalid data", code: -1, userInfo: nil))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let employeesData = try decoder.decode(EmployeeData.self, from: data)
                completion(employeesData.employees, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
}
