//
//  TabelViewCell.swift
//  SquareList
//
//  Created by Артeмий Шлесберг on 13.01.2023.
//

import Foundation
import UIKit

class EmployeeCell: UITableViewCell {
    
    static internal let imageCache = NSCache<NSString, UIImage>()
    static var imageSize = CGSize(width: 32, height: 32)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var config = defaultContentConfiguration()
        config.imageProperties.cornerRadius = 8
        config.imageProperties.maximumSize = EmployeeCell.imageSize
        config.imageProperties.reservedLayoutSize = EmployeeCell.imageSize
        contentConfiguration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(employee: Employee) {
        var config = contentConfiguration as! UIListContentConfiguration
        config.text = employee.fullName
        config.secondaryText = employee.emailAddress
  
        if let image = EmployeeCell.imageCache.object(forKey: employee.photoUrlSmall as NSString) {
            config.image = image
        } else {
            config.image =  UIImage(systemName: "person.fill")
            DispatchQueue.global().async {
                guard let url = URL(string: employee.photoUrlSmall) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                EmployeeCell.imageCache.setObject(image, forKey: employee.photoUrlSmall as NSString)
                DispatchQueue.main.async { [weak self] in
                    config.image = image
                    self?.contentConfiguration = config
                }
            }
        }
        contentConfiguration = config
    }
}
