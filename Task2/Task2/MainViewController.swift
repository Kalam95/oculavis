//
//  MainViewController.swift
//  Task2
//
//  Created by IT Devices In House on 10.06.21.
//

import UIKit

class MainViewController: UIViewController {
    
    private static let SEGUE_NAME = "OpenListSegue"

    @IBOutlet var textfieldNumber: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MainViewController.SEGUE_NAME {
            if let listVC = segue.destination as? ListViewController {
                listVC.numberOfPokemon = Int(textfieldNumber.text ?? "1")
            }
        }
    }

    @IBAction func onStartTapped(_ sender: UIButton) {
        performSegue(withIdentifier: MainViewController.SEGUE_NAME, sender: nil)
    }
}

