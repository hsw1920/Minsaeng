//
//  ProfileNameCreationReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import Foundation
import ReactorKit
import RxCocoa

enum TextFieldState {
    case empty, none, success, warning
}

final class ProfileNameCreationReactor: Reactor {
    enum Action {
        case textFieldValueChanged(String)
        case buttonTapped
    }
    
    enum Mutation {
        case setTitleIsEmpty(Bool)
        case setIsPresent(Bool)
        case setTextFieldState(TextFieldState)
        case setIsActive(Bool)
    }
    
    struct State {
        var textFieldIsEmpty: Bool = true
        var isPresent: Bool = false
        var textFieldState: TextFieldState = .none
        var isActive: Bool = false
    }
    
    // MARK: Property
    var initialState: State = .init()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textFieldValueChanged(let text):
            switch isValidName(name: text) {
            case .empty:
                return Observable.concat([
                    .of(.setTitleIsEmpty(true)),
                    .of(.setTextFieldState(.empty)),
                    .of(.setIsActive(false))
                ])
            case .none:
                return Observable.concat([
                    .of(.setTitleIsEmpty(false)),
                    .of(.setTextFieldState(.none)),
                    .of(.setIsActive(false))
                ])
            case .success:
                return Observable.concat([
                    .of(.setTitleIsEmpty(false)),
                    .of(.setTextFieldState(.success)),
                    .of(.setIsActive(true))
                ])
            case .warning:
                return Observable.concat([
                    .of(.setTitleIsEmpty(false)),
                    .of(.setTextFieldState(.warning)),
                    .of(.setIsActive(false))
                ])
            }
        case .buttonTapped:
            return Observable.just(.setIsPresent(true))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTitleIsEmpty(let isEmpty):
            newState.textFieldIsEmpty = isEmpty
        case .setIsPresent(let isPresent):
            newState.isPresent = isPresent
        case .setTextFieldState(let state):
            newState.textFieldState = state
        case .setIsActive(let isActive):
            newState.isActive = isActive
        }
        return newState
    }

    private func isValidName(name: String) -> TextFieldState {
        switch name.count {
        case 0: return .empty
        case 1: return .none
        case 2...4:
            // 한글 자모 포함
            //^[가-힣ㄱ-ㅎㅏ-ㅣ]{2,4}$
            let nameRegEx = "^[가-힣]{2,4}$"
            let pred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
            if pred.evaluate(with: name) {
                return .success
            }
            return .warning
        default: return .warning
        }
    }
}
