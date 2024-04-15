//
//  BaseViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import UIKit
import RxSwift
import SnapKit

class BaseViewController: UIViewController {
    final var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func setupUI() { }
}
