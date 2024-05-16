//
//  CreateFormCoordinatorInterface.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import Foundation

protocol CreateFormCoordinatorInterface {
    func finishCreateForm(_ viewController: CreateFormViewController)
    func presentCamera(_ viewController: CreateFormViewController, option: CaptureOption)
}
