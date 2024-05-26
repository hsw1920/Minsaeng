//
//  MainReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/18.
//

import ReactorKit
import RxCocoa

final class MainReactor: Reactor {
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case pushComplaint
        case pushViewAllComplaints
    }
    
    enum Mutation {
        case goToCamera
        case goToViewAllComplaints
        case updateRecentComplaints
    }
    
    struct State {
        @Pulse var isPushComplaint: Bool = false
        @Pulse var isPushViewAllComplaints: Bool = false
        var complaints: [RecentComplaint] = []
    }
    
    // MARK: Property
    var initialState: State = .init()
    let realmManager = RealmManager()
    
    init() {
        self.initialState.complaints =  realmManager.loadRecentComplaints()
    }
    
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.updateRecentComplaints)
        case .viewWillAppear:
            print("ViewWillAppear")
            return .just(.updateRecentComplaints)
        case .pushComplaint:
            return Observable.just(.goToCamera)
        case .pushViewAllComplaints:
            return Observable.just(.goToViewAllComplaints)
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
        }
        return newState
    }
    
    private func updateRecentComplaints() -> [RecentComplaint] {
        return realmManager.loadRecentComplaints()
    }
}
