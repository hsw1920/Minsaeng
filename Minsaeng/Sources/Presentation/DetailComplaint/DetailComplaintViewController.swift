//
//  DetailComplaintViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/21.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailComplaintViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    
    let detailComplaintView = DetailComplaintView()
    private let exitBarItem: UIBarButtonItem = .init()
    
    private let viewModel: DetailComplaintViewModel

    init(viewModel: DetailComplaintViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.exitBarItem.customView = detailComplaintView.exitButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = detailComplaintView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configure()
        bind()
    }
    
    func setupNavigation() {
        let dateFormatter = MSDateFormatter()
        let formattedDate = dateFormatter.getY4M2D4(date: viewModel.complaint.date)
        title = formattedDate
        
        navigationItem.rightBarButtonItem = exitBarItem
        navigationItem.rightBarButtonItem?.tintColor = .MSBlack
    }
    
    private func configure() {
        detailComplaintView.label.text = viewModel.complaint.violationType.description
    }
    
    private func bind() {
        detailComplaintView.exitButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
