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
        case pushComplaint
        case pushViewAllComplaints
    }
    
    enum Mutation {
        case goToCamera
        case goToViewAllComplaints
    }
    
    struct State {
        @Pulse var isPushComplaint: Bool = false
        @Pulse var isPushViewAllComplaints: Bool = false
        var complaints: [RecentComplaint] = RecentComplaint.list
    }
    
    // MARK: Property
    var initialState: State = .init()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.concat([
                .empty()
            ])
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
        }
        return newState
    }
}
