//
//  CreateFormReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import ReactorKit
import RxCocoa

final class CreateFormReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    // MARK: Property
    var initialState: State = .init()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        return newState
    }

}
