//
//  HomeViewController.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 5.10.21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "HomeVC"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .organize)
//        navigationItem.setHidesBackButton(true, animated: true)
    }
}
