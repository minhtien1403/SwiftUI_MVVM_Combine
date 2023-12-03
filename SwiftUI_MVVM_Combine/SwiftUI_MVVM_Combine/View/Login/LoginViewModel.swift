//
//  LoginViewModel.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import Combine

final class LoginViewModel: ObservableObject {
    
    @Published var count = 0
        
    func increaseCount() {
        count += 1
        print(count)
    }
    
}
