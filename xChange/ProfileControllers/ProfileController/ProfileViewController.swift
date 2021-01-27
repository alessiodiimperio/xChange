//
//  ProfileViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit

class ProfileViewController: UIViewController {
    weak var coordinator:ProfileCoordinator?
    var viewModel:ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func singOutTapped(_ sender: Any) {
        coordinator?.signOut()
    }
}
