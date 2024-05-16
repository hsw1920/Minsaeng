//
//  CameraCoordinatorInterface.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/16.
//

import Foundation

protocol CameraCoordinatorInterface {
    func cancelCamera(_ viewController: CameraViewController)
    func finishCamera(_ viewController: CameraViewController, option: CaptureOption, imageData: Data)
}
