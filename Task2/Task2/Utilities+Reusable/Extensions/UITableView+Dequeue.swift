//
//  UITableView+Dequeue.swift
//  Task2
//
//  Created by mehboob Alam.
//

import UIKit

extension UITableView {
    
    // This can be used as follows:
    // tableView.registerCell(type: PokemonCell.self)
    func registerCell(type cellType: UITableViewCell.Type) {
        let name = String(describing: cellType.self)
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    // This can be used as follows:
    // let cell = tableView.dequeueTypedCell(for: indexPath)
    func dequeueTypedCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
