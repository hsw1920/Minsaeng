//
//  ViewAllReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import ReactorKit
import RxCocoa

final class ViewAllReactor: Reactor {
    deinit {
        print("deinit: \(self)")
    }
    enum Action {
        case viewDidLoad
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var complaints: [Complaint] = Complaint.list
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
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}

