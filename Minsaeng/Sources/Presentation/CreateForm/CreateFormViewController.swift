//
//  CreateFormViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import Foundation
import ReactorKit

final class CreateFormViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    
    private let coordinator: CreateFormCoordinator
    
    // MARK: Init
    init(with reactor: CreateFormReactor, coordinator: CreateFormCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CreateFormViewController: View {
    func bind(reactor: CreateFormReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CreateFormReactor) {
        
    }
    
    private func bindState(reactor: CreateFormReactor) {
        
    }
}
