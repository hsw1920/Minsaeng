//
//  DetailComplaintViewModel.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/21.
//

import RxSwift
import RxCocoa
import RxRelay

final class DetailComplaintViewModel {
    let complaint: Complaint
    let images: BehaviorRelay<[String]> = .init(value: [])
    
    init(complaint: Complaint) {
        self.complaint = complaint
        setImages()
    }
    
    private func setImages() {
        var images = [complaint.requiredImage]
        if let optionalImage = complaint.optionalImage {
            images.append(optionalImage)
        }
        self.images.accept(images)
    }
}



