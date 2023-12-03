//
//  Combine.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 01/12/2023.
//

import Combine
import SwiftUI

extension Publisher {
    func ignoreFailure() -> AnyPublisher<Output, Never> {
        self.catch { _ in Empty() }
            .eraseToAnyPublisher()
    }
    
    func handleFailure(error: Binding<IDError?>) -> AnyPublisher<Output, Never> {
        self.handleEvents(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                error.wrappedValue = IDError(error: err)
            case .finished:
                break
            }
        })
        .ignoreFailure()
    }
    
    func sink() -> AnyCancellable {
        return self.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}

struct IDError: LocalizedError, Identifiable {
    let id = UUID().uuidString
    let error: Error
    
    var errorDescription: String? {
        error.localizedDescription
    }
}
