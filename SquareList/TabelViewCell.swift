//
//  TabelViewCell.swift
//  SquareList
//
//  Created by Артeмий Шлесберг on 13.01.2023.
//

import Foundation
import UIKit

class EmployeeCell: UITableViewCell {
//    var nameLabel: UILabel = UILabel()
//    var teamLabel: UILabel = UILabel()
//    var photoImageView: UIImageView! = UIImageView()
    
    static private let imageCache = NSCache<NSString, UIImage>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(employee: Employee) {
        
        textLabel?.text = employee.fullName
        detailTextLabel?.text = employee.team
        if let image = EmployeeCell.imageCache.object(forKey: employee.photoUrlSmall as NSString) {
            imageView?.image = image
        } else {
            imageView?.image = UIImage(named: "placeholder")
            DispatchQueue.global().async {
                guard let url = URL(string: employee.photoUrlSmall) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                EmployeeCell.imageCache.setObject(image, forKey: employee.photoUrlSmall as NSString)
                DispatchQueue.main.async { [weak self] in
                    self?.imageView?.image = image
                }
            }
        }
    }
}
