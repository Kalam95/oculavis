//
//  MainViewController.swift
//  Task2
//
//  Created by IT Devices In House on 10.06.21.
//

import UIKit

class MainViewController: BaseViewController {
    
    private static let SEGUE_NAME = "OpenListSegue"

    @IBOutlet var textfieldNumber: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .lightRedColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MainViewController.SEGUE_NAME {
            if let listVC = segue.destination as? ListViewController {
                let apiClient = PokemonAPI(networkClient: NetworkClient(baseUrl: AppURL.base.rawValue))
                let count = Int(textfieldNumber.text ?? "1") ?? 1
                listVC.viewModel = ListViewModel(apiCleint: apiClient, count: count)
            }
        }
    }

    @IBAction func onStartTapped(_ sender: UIButton) {
        guard Int(textfieldNumber.text ?? "") != nil else {
            self.showAlert(title: "Alert!!", description: "Please Enter a valid Number", primaryAction: ("OK", nil))
            return
        }
        performSegue(withIdentifier: MainViewController.SEGUE_NAME, sender: nil)
    }
}

