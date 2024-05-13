//
//  CreateFormReactor.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import Foundation
import ReactorKit
import RxCocoa
import UIKit

final class CreateFormReactor: Reactor {
    enum Action {
        case viewDidLoad
        case violationButtonTapped(IndexPath)
        case replyButtonTapped
        case confirmButtonTapped
        case editDetailContent(String)
        case shootCamera(Data?)
    }
    
    enum Mutation {
        case setComponent
        case setViolation(IndexPath)
        case setDetailContent(IndexPath)
        case setDetailContentString(String)
        case toggleReply
        case updateCaptureImage(Data)
    }
    
    struct State {
        var violations: [ViolationType] = ViolationType.mock
        var vehicleNumber: String = ""
        var detailContent: String = ""
        var isSelectedReplyButton: Bool = true
        var captureImageData: Data?
    }
    
    // MARK: Property
    var initialState: State = .init()
    var readyToConfirm = PublishSubject<CreateFormComponentImpl>()
    var component: CreateFormComponent!
    
    // MARK: Init
    init(component: CreateFormComponent) {
        self.component = component
        self.initialState.violations[component.violationType.rawValue].isSelected = true
        self.initialState.detailContent = component.violationType.description
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
        case .shootCamera(let image):
            guard let image else { return .empty() }
            return .just(.updateCaptureImage(image))
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
            newState.detailContent = Violation(rawValue: indexPath.row)?.description ?? ""
        case .toggleReply:
            newState.isSelectedReplyButton.toggle()
        case .setDetailContentString(let text):
            newState.detailContent = text
        case .updateCaptureImage(let image):
            newState.captureImageData = image
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
    
    private func makeComponent() -> CreateFormComponentImpl {
        let violationId = currentState.violations.firstIndex(where: { $0.isSelected }) ?? 0
        let violationType = Violation(rawValue: violationId) ?? .etc
        let vehicleNumber = currentState.vehicleNumber
        let detailContent = currentState.detailContent
        let date = Date.now
        let name = component.name
        let phoneNumber = component.phoneNumber
        let imageData = currentState.captureImageData
        let isReceived = currentState.isSelectedReplyButton
        
        return CreateFormComponentImpl(vehicleNumber: vehicleNumber,
                                       violationType: violationType,
                                       detailContent: detailContent,
                                       date: date,
                                       name: name,
                                       phoneNumber: phoneNumber, 
                                       isReceived: isReceived,
                                       imageData: imageData)
    }
}
