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
    
//    let images: PublishRelay<[String]> = .init()
    
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
        bind()
        configure()
    }
    
    func setupNavigation() {
        let dateFormatter = MSDateFormatter()
        let formattedDate = dateFormatter.getTimeAll(date: viewModel.complaint.date)
        title = formattedDate
        
        navigationItem.rightBarButtonItem = exitBarItem
        navigationItem.rightBarButtonItem?.tintColor = .MSBlack
    }
    
    private func configure() {
        detailComplaintView.violationTypeLabel.text = viewModel.complaint.violationType.toString
        detailComplaintView.locationLabel.text = viewModel.complaint.location
        detailComplaintView.detailTextView.text = viewModel.complaint.detailContent
    }
    
    private func bind() {
        detailComplaintView.exitButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.images
            .bind(to: detailComplaintView.imageCollectionView.rx.items(
                cellIdentifier: DetailComplaintImageCell.reuseIdentifier,
                cellType: DetailComplaintImageCell.self
            )) { index, item, cell in
                cell.configure(image: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.images
            .map{ $0.count < 2 }
            .bind(to: detailComplaintView.pageControl.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
