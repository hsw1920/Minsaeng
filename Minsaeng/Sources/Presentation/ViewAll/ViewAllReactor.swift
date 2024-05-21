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
        case pushDetailComplaint(idx: Int)
    }
    
    enum Mutation {
        case goToDetailComplaint(idx: Int)
    }
    
    struct State {
        @Pulse var complaints: [Complaint] = Complaint.list
        @Pulse var isPushDetailComplaint: (Bool, Int) = (false, 0)
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
        case .pushDetailComplaint(let idx):
            return .just(.goToDetailComplaint(idx: idx))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .goToDetailComplaint(let idx):
            newState.isPushDetailComplaint = (true, idx)
        }
        return newState
    }
}

