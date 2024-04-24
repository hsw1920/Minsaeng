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
    
    var description: String {
        switch self {
        case .hydrant: "소화전에 불법주정차"
        case .intersection: "교차로 모퉁이에 불법주정차"
        case .busStop: "버스 정류소에 불법주정차"
        case .crosswalk: "횡단보도에 불법주정차"
        case .schoolZone: "어린이 보호구역에 불법주정차"
        case .sidewalk: "인도에 불법주정차"
        case .etc: "해당 내용으로 불법주정차"
        }
    }
}

struct CreateFormComponent {
    let violationType: Violation
    let vehicleNumber: String
    let detailContent: String
    let date: Date
    let name: String
    let phoneNumber: String
}

final class CreateFormReactor: Reactor {
    enum Action {
        case viewDidLoad
        case violationButtonTapped(IndexPath)
        case replyButtonTapped
        case confirmButtonTapped
        case editDetailContent(String)
    }
    
    enum Mutation {
        case setComponent
        case setViolation(IndexPath)
        case setDetailContent(IndexPath)
        case setDetailContentString(String)
        case toggleReply
    }
    
    struct State {
        var violations: [ViolationType] = ViolationType.mock
        var vehicleNumber: String = ""
        var detailContent: String = ""
        var isSelectedReplyButton: Bool = true
    }
    
    // MARK: Property
    var initialState: State = .init()
    var readyToConfirm = PublishSubject<CreateFormComponent>()
    
    // MARK: Init
    init(component: Violation) {
        self.initialState.violations[component.rawValue].isSelected = true
        self.initialState.detailContent = component.description
        self.initialState.vehicleNumber = " <#차량번호> "
    }
    
    deinit {
        print(type(of: self), #function)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setComponent)
        case .violationButtonTapped(let indexPath):
            return Observable.concat([
                .just(.setViolation(indexPath)),
                .just(.setDetailContent(indexPath))
            ])   
        case .replyButtonTapped:
            return .just(.toggleReply)
        case .confirmButtonTapped:
            let component = makeComponent()
            readyToConfirm.onNext(component)
            return Observable.empty()
        case .editDetailContent(let text):
            return .just(.setDetailContentString(text))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setComponent:
            newState.vehicleNumber = initialState.vehicleNumber
            newState.detailContent = initialState.detailContent
        case .setViolation(let indexPath):
            newState.violations = parseSelectedViolationType(with: newState.violations, 
                                                             index: indexPath.row)
        case .setDetailContent(let indexPath):
            let selectedViolation = newState.violations[indexPath.row]
            newState.detailContent = Violation(rawValue: indexPath.row)?.description ?? ""
        case .toggleReply:
            newState.isSelectedReplyButton.toggle()
        case .setDetailContentString(let text):
            newState.detailContent = text
        }
        return newState
    }
}

extension CreateFormReactor {
    private func parseSelectedViolationType(with violations: [ViolationType], 
                                            index: Int) -> [ViolationType] {
        var newViolations = violations
        for selected in 0..<violations.count {
            index == selected ? 
            (newViolations[selected].isSelected = true)
            : (newViolations[selected].isSelected = false)
        }
        return newViolations
    }
    
    private func makeComponent() -> CreateFormComponent {
        let violationId = currentState.violations.firstIndex(where: { $0.isSelected }) ?? 0
        let violationType = Violation(rawValue: violationId) ?? .etc
        let vehicleNumber = currentState.vehicleNumber
        let detailContent = currentState.detailContent
        let date = Date.now
        let name = "이름"
        let phoneNumber = "휴대폰 번호"
        
        return CreateFormComponent(violationType: violationType,
                                   vehicleNumber: vehicleNumber,
                                   detailContent: detailContent,
                                   date: date,
                                   name: name,
                                   phoneNumber: phoneNumber)
    }
}
