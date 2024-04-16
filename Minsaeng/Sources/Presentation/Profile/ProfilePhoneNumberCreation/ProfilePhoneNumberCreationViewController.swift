//
//  ProfilePhoneNumberCreationViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ProfilePhoneNumberCreationViewController: BaseViewController {
    
    // MARK: Init
    init(with reactor: ProfilePhoneNumberCreationReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ProfilePhoneNumberCreationViewController: View {
    
    func bind(reactor: ProfilePhoneNumberCreationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfilePhoneNumberCreationReactor) {
        
    }
    
    private func bindState(reactor: ProfilePhoneNumberCreationReactor) {
        
    }
}
