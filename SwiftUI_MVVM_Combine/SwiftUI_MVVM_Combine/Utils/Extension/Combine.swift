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
    
    func sink() -> AnyCancellable {
        return self.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}
