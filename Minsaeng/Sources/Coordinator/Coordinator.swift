//
//  Coordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/17.
//

import Foundation

protocol Coordinator {
    protocol Coordinator: AnyObject {
        var childCoordinators: [Coordinator] { get set }
        func start()
    }
}
