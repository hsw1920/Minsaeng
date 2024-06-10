//
//  MainReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/18.
//

import ReactorKit
import RxCocoa
import CoreLocation
import UIKit

final class MainReactor: NSObject, Reactor {
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case pushViewAllComplaints
        case checkCLAuthorization
    }
    
    enum Mutation {
        case goToCamera
        case goToViewAllComplaints
        case setAlert
        case updateRecentComplaints
    }
    
    struct State {
        @Pulse var isPushComplaint: Bool = false
        @Pulse var isPushViewAllComplaints: Bool = false
        @Pulse var setAlert: Bool = false
        var complaints: [RecentComplaint] = []
    }
    
    // MARK: Property
    var initialState: State = .init()
    let realmManager = RealmManager()
    private var locationManager = CLLocationManager()
    
    override init() {
        self.initialState.complaints =  realmManager.loadRecentComplaints()
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.updateRecentComplaints)
        case .viewWillAppear:
            print("ViewWillAppear")
            return .just(.updateRecentComplaints)
        case .pushViewAllComplaints:
            return .just(.goToViewAllComplaints)
        case .checkCLAuthorization:
            // 위치 서비스 권한 상태 확인
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .notDetermined:
                // 권한이 요청되지 않음
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                // 위치 서비스 사용 제한 또는 거부됨
                return .just(.setAlert)
            case .authorizedWhenInUse, .authorizedAlways:
                // 위치 서비스 사용 허용됨
                return .just(.goToCamera)
            default:
                break
            }
            return .empty()
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .goToCamera:
            newState.isPushComplaint = true
        case .goToViewAllComplaints:
            newState.isPushViewAllComplaints = true
        case .updateRecentComplaints:
            newState.complaints = updateRecentComplaints()
        case .setAlert:
            newState.setAlert = true
        }
        return newState
    }
    
    private func updateRecentComplaints() -> [RecentComplaint] {
        return realmManager.loadRecentComplaints()
    }
}
