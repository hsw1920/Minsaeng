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

