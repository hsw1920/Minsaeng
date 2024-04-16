//
//  ProfilePhoneNumberCreationReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import Foundation
import ReactorKit
import RxCocoa

final class ProfilePhoneNumberCreationReactor: Reactor {
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
            switch isValidPhoneNumber(phoneNumber: text) {
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

    private func isValidPhoneNumber(phoneNumber: String) -> TextFieldState {
        let phoneNumberRegEx = "^010[0-9]{8}$"
        let numberAllRegEx = "^[0-9]{0,11}$"
        let numberAllPred = NSPredicate(format:"SELF MATCHES %@", numberAllRegEx)
        let pred = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegEx)
        
        if !numberAllPred.evaluate(with: phoneNumber) {
            return .warning
        }
        else if pred.evaluate(with: phoneNumber) {
            return .success
        }
        else {
            switch phoneNumber.count {
            case 0: return .empty
            case 1..<11: return .none
            default: return .warning
            }
        }
    }
}


