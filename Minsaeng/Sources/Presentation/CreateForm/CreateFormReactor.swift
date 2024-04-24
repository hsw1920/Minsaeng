//
//  CreateFormReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import Foundation
import ReactorKit
import RxCocoa

enum Violation: Int, CaseIterable {
    case hydrant = 0
    case intersection
    case busStop
    case crosswalk
    case schoolZone
    case sidewalk
    case etc
}

final class CreateFormReactor: Reactor {
    enum Action {
        case violationButtonTapped(IndexPath)
        case replyButtonTapped
    }
    
    enum Mutation {
        case setViolation(IndexPath)
        case setDetailContent(IndexPath)
        case toggleReply
    }
    
    struct State {
        var violations: [ViolationType] = ViolationType.mock
        var placeholder: String = ""
        var isSelectedReplyButton: Bool = true
    }
    
    // MARK: Property
    var initialState: State = .init()
    
    // MARK: Init
    init(component: Violation) {
        self.initialState.violations[component.rawValue].isSelected = true
        self.initialState.placeholder = self.initialState.violations[component.rawValue].description
    }
    
    deinit {
        print(type(of: self), #function)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .violationButtonTapped(let indexPath):
            return Observable.concat([
                .just(.setViolation(indexPath)),
                .just(.setDetailContent(indexPath))
            ])   
        case .replyButtonTapped:
            return .just(.toggleReply)
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setViolation(let indexPath):
            newState.violations = parseSelectedViolationType(with: newState.violations, index: indexPath.row)
        case .setDetailContent(let indexPath):
            let selectedViolation = newState.violations[indexPath.row]
            newState.placeholder = selectedViolation.description
        case .toggleReply:
            newState.isSelectedReplyButton.toggle()
        }
        return newState
    }
}

extension CreateFormReactor {
    private func parseSelectedViolationType(with violations: [ViolationType], index: Int) -> [ViolationType] {
        var newViolations = violations
        for selected in 0..<violations.count {
            index == selected ? 
            (newViolations[selected].isSelected = true)
            : (newViolations[selected].isSelected = false)
        }
        return newViolations
    }
}
