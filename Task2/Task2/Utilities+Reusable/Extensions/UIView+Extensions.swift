//
//  UIView+Extensions.swift
//  Task2
//
//  Created by mehboob Alam.
//

import UIKit

extension UIView {
    @discardableResult
    public func fromNib<T: UIView>(type: T.Type) -> UIView? {
        let nibName = String(describing: type)
        guard let view = Bundle(for: type).loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            return nil
        }
        self.addSubview(view)
        view.frame = self.bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        return view
    }

    public func applyDropShadow(radius: CGFloat, opacity: Float = 0.3, color: UIColor = UIColor.black.withAlphaComponent(0.8)) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }

    public func roundedBorders(radius: CGFloat, borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
}
