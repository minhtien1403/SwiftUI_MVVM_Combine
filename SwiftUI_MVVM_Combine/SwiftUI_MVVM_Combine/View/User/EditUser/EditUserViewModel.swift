//
//  EditUserViewModel.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 08/12/2023.
//

import Foundation

final class EditUserViewModel: ObservableObject {
    
    @Published var user: User
    private var onUpdate: (User) -> Void
    
    init(user: User, onUpdate: @escaping (User) -> Void) {
        self.user = user
        self.onUpdate = onUpdate
    }
    
    func updateUser() {
        onUpdate(user)
    }
}
