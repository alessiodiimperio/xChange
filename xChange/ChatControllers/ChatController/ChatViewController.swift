//
//  ChatViewController.swift
//  xChange
//
//  Created by Alessio on 2021-01-25.
//

import UIKit

class ChatViewController: UIViewController {
    var viewModel:ChatViewModel!
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
    }
    
    private func setupObservables() {
        
    }
}
