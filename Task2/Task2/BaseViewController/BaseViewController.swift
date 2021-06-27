//
//  BaseViewController.swift
//  Task2
//
//  Created by mehboob Alam.
//

import UIKit


/// BaseViewContrroller, which contains code related to all the view controllers,
/// such as common navigation bar settings, or showing and hiding alerts
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func showAlert(title: String, description: String, attributedDescription: NSAttributedString? = nil, primaryAction: PrimaryAlertView.Action, secondaryAction: PrimaryAlertView.Action? = nil) {
        let alert = PrimaryAlertView(frame: self.view.window?.frame ?? self.view.frame)
        alert.configure(title: title, description: description, attributedDescription: attributedDescription,
                        primaryAction: primaryAction, secondaryAction: secondaryAction)
        self.addToViewWindow(subView: alert)
    }

    public func addToViewWindow(subView: UIView) {
        view.window?.addSubview(subView)
    }
}
