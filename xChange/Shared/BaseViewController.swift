//
//  BaseViewController.swift
//  xChange
//
//  Created by Alessio on 2021-04-27.
//

import RxSwift
import RxCocoa
import UIKit

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
    }
}
