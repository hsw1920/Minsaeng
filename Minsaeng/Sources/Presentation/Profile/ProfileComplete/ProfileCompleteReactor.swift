//
//  ProfileCompleteReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import ReactorKit
import RxCocoa

final class ProfileCompleteReactor: Reactor {
    enum Action {
        case pushButtonTapped
    }
    
    enum Mutation {
        case goToHome
    }
    
    struct State {
        var isPushHome: Bool = false
    }
    
    // MARK: Property
    var initialState: State = .init()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> { 
        switch action {
        case .pushButtonTapped:
            return Observable.just(.goToHome)
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State { 
        var newState = state
        switch mutation {
        case .goToHome:
            newState.isPushHome = true
        }
        return newState
    }

}
