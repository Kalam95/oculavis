//
//  MainViewController.swift
//  Task1
//
//  Created by Moritz Werner on 10.06.21.
//

import UIKit

class MainViewController: UIViewController {
    
    private static let SEGUE_NAME = "OpenTaskSegue"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MainViewController.SEGUE_NAME {
            if let taskVC = segue.destination as? TaskViewController {
                print("Task 1 opened")
                taskVC.taskName = sender as? String
            }
        }
    }
    
    @IBAction func onTaskButtonTaped(_ sender: UIButton) {
        performSegue(withIdentifier: MainViewController.SEGUE_NAME, sender: sender.titleLabel)
    }
}

