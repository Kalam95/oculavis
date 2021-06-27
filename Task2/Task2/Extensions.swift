//
//  Extensions.swift
//  Task2
//
//  Created by IT Devices In House on 10.06.21.
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
    // let cell = tableView.dequeueTypedCell(for: indexPath, type: PokemonCell.self)
    func dequeueTypedCell<T: UITableViewCell>(for indexPath: IndexPath, type cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: cellType.self), for: indexPath) as! T
    }
}

extension UIColor {
    
    // This function returns a pre-defined UIColor for all kind of type strings that PokeAPI returns
    static func pokemonColor(for type: String?) -> UIColor {
        guard let type = type else { return .white }
        
        switch type {
        case "normal":
            return PokemonColors.normal
        case "psychic":
            return PokemonColors.psychic
        case "steel":
            return PokemonColors.steel
        case "water":
            return PokemonColors.water
        case "fire":
            return PokemonColors.fire
        case "grass":
            return PokemonColors.grass
        case "bug":
            return PokemonColors.bug
        case "electric":
            return PokemonColors.electric
        case "poison":
            return PokemonColors.poison
        case "ground":
            return PokemonColors.ground
        case "rock":
            return PokemonColors.rock
        case "fairy":
            return PokemonColors.fairy
        case "fighting":
            return PokemonColors.fighting
        case "ghost":
            return PokemonColors.ghost
        case "ice":
            return PokemonColors.ice
        case "dragon":
            return PokemonColors.dragon
        case "dark":
            return PokemonColors.dark
        default:
            return .white
        }
    }
    
    private enum PokemonColors {
        static let normal = UIColor(hex: "#DAD6CD")!
        static let psychic = UIColor(hex: "#F368E0")!
        static let steel = UIColor(hex: "#A4B0BE")!
        static let water = UIColor(hex: "#74B9FF")!
        static let fire = UIColor(hex: "#FF6B6B")!
        static let grass = UIColor(hex: "#00B894")!
        static let bug = UIColor(hex: "#8BC34A")!
        static let electric = UIColor(hex: "#FFD32A")!
        static let poison = UIColor(hex: "#9575CD")!
        static let ground = UIColor(hex: "#A1887F")!
        static let rock = UIColor(hex: "#616161")!
        static let fairy = UIColor(hex: "#F8A5C2")!
        static let fighting = UIColor(hex: "#FF7043")!
        static let ghost = UIColor(hex: "#7C587F")!
        static let ice = UIColor(hex: "#B2EBF2")!
        static let dragon = UIColor(hex: "#6C5CE7")!
        static let dark = UIColor(hex: "#353B48")!
    }
    
    public convenience init?(hex: String?) {
        guard let hexString = hex else { return nil }
        
        let r, g, b: CGFloat
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                if hexColor.count == 6 {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        return nil
    }
}


