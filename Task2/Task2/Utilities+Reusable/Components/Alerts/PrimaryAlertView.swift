//
//  Alert.swift
//  Task2
//
//  Created by mehboob Alam.
//
import  UIKit
///**NOTE:** This si the specific alert with 2 buttons only, however just lil bit of cahneg in code can make it for multiple
/** An alert class to show error, it can have 2 actions
 - Primary: main and colored button
 - Secondary: outlined and low priority action
*/
open class PrimaryAlertView: UIView {

    public typealias Action = (title: String, completion: (() -> Void)?)
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var actionContainerStackView: UIStackView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()

    }

    private func setupView() {
        fromNib(type: Self.self)
        mainContainerView.applyDropShadow(radius: 20) // an expensive and dynamic shadow.
        mainContainerView.roundedBorders(radius: 20)
        backgroundColor = .clear
        headingLabel.textColor = UIColor.black

    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    open override func removeFromSuperview() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: {_ in
            super.removeFromSuperview()
        })
    }

    public func configure(title: String, description: String,  attributedDescription: NSAttributedString? = nil, primaryAction: Action, secondaryAction: Action?) {
        self.headingLabel.text = title
        self.descriptionLabel.text = description
        if let attributedDescription = attributedDescription {
            self.descriptionLabel.attributedText = attributedDescription
        }
        self.addButton(primaryAction)
        if let action = secondaryAction {
            self.addButton(action, isPrimary: false)
        }
    }

    func addButton(_ action: Action, isPrimary: Bool = true, hideAlert: Bool = true) {
        let button: UIButton = isPrimary ? PrimarySolidButton() : SecondaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.setTitle(action.title, for: .normal)
        button.sizeToFit()
        button.addAction(UIAction(handler: { [weak self] _ in
            action.completion?()
            if hideAlert {
                self?.removeFromSuperview()
            }
        }), for: .touchUpInside)
        self.actionContainerStackView.addArrangedSubview(button)
         // ratio on the basis of screen for button height
        button.heightAnchor.constraint(equalToConstant: .minRelative(size: 55)).isActive = true
    }

}

