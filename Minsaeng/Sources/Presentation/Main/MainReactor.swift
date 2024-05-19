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
        case pushComplaint
    }
    
    enum Mutation {
        case goToCamera
    }
    
    struct State {
        var isPushComplaint: Bool = false
        var complaints: [RecentComplaint] = RecentComplaint.list
    }
    
    // MARK: Property
    var initialState: State = .init()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pushComplaint:
            return Observable.just(.goToCamera)
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .goToCamera:
            newState.isPushComplaint = true
        }
        return newState
    }

}
