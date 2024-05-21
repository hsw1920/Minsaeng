//
//  ViewAllReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import ReactorKit
import RxCocoa
import Foundation

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
        case fetchUserInfo
    }
    
    struct State {
        @Pulse var complaints: [Complaint] = Complaint.list
        @Pulse var isPushDetailComplaint: (Bool, idx: Int) = (false, 0)
        @Pulse var userInfo: (name: String, count: Int) = ("", 0)
    }
    
    // MARK: Property
    var initialState: State = .init()
    let realmManager = RealmManager()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.concat([
                .just(.fetchUserInfo)
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
        case .fetchUserInfo:
            guard let profile = realmManager.loadProfile() else { return newState }
            newState.userInfo = (profile.name, state.$complaints.value.count)
        }
        return newState
    }
}

