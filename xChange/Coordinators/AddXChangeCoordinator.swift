//
//  AddXChangeCoordinator.swift
//  xChange
//
//  Created by Alessio on 2021-01-26.
//

import UIKit
import Swinject
import SwinjectStoryboard

protocol AddXChangeCoordinatorDelegate: AnyObject {
}

class AddXChangeCoordinator:NSObject, Coordinator {
    let container: Container
    var childrenCoordinators = [Coordinator]()
    var navigationController:UINavigationController
    weak var delegate: AddXChangeCoordinatorDelegate?
    
    init(navigationController:UINavigationController, container: Container, delegate: AddXChangeCoordinatorDelegate?){
        self.navigationController = navigationController
        self.container = container
        self.delegate = delegate
    }
    
    func start() {
        let delegate: AddXChangeViewControllerDelegate? = self
        let vc = container.resolve(AddXChangeController.self, argument: delegate)!
        navigationController.tabBarItem.image = UIImage(systemName: "plus.circle.fill")
        navigationController.tabBarItem.title = "Create"
        navigationController.setViewControllers([vc], animated: false)
        navigationController.isNavigationBarHidden = true
    }
}

extension AddXChangeCoordinator: AddXChangeViewControllerDelegate, UINavigationControllerDelegate {
    func startCamera(imagePickerDelegate: AddXChangeController) {
        let viewController = UIImagePickerController()
        viewController.delegate = imagePickerDelegate
        viewController.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
           viewController.sourceType = .camera
        } else {
           viewController.sourceType = .photoLibrary
        }
        navigationController.present(viewController, animated: true)
    }
    
    func setSelectedImage(_ image: UIImage?, to viewController: AddXChangeController) {
        guard let image = image else { return }
        
        viewController.viewModel.setImageViewImage(to: image)
        viewController.dismiss(animated: true)
    }
    
    func dismissViewController(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func present(_ viewController: UIViewController, onNav navigationController: UINavigationController?, animated: Bool) {
        navigationController?.present(viewController, animated: true)
    }
}
