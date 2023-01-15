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
        case content([String:[Employee]])
        case error(String)
    }
    
    private var dataSource: EmployeesDataSource
    
    @Published var state: State = .error("")
    private var cancellables = Set<AnyCancellable>()

    internal init(dataSource: EmployeesDataSource) {
        self.dataSource = dataSource
    }
    
    func reload() {
        dataSource.fetch()
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self.state = .error(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [unowned self] employeesData in
                let employes = employeesData.employeesByTeam
                if employes.isEmpty {
                    self.state = .error("No emplyees")
                } else {
                    self.state = .content(employes)
                }
            })
            .store(in: &cancellables)
    }
    
}
