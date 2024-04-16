//
//  ProfileCompleteViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ProfileCompleteViewController: BaseViewController {
 
    // MARK: Init
    init(with reactor: ProfileCompleteCreationReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ProfileCompleteViewController: View {
    func bind(reactor: ProfileCompleteCreationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfileCompleteCreationReactor) {
        
    }
    
    private func bindState(reactor: ProfileCompleteCreationReactor) {
        
    }
}

