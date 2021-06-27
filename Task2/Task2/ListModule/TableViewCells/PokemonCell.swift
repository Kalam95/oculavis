//
//  PokemonCell.swift
//  Task2
//
//  Created by IT Devices In House on 10.06.21.
//

import UIKit

class PokemonCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!

    override func prepareForReuse() {
        itemImage.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.roundedBorders(radius: .minRelative(size: 20))
    }

    func populateCell(with data: Pokemon?) {
        guard let data = data else {
            return
        }
        colorView.backgroundColor = UIColor.random()
        nameLabel.text = data.name ?? "N/A"
        self.itemImage.setImage(from: data.imageURl ?? "")
    }
}

