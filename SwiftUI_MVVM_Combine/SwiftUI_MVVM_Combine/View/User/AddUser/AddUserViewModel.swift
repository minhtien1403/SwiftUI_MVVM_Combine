//
//  AddUserViewModel.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 05/12/2023.
//

import Foundation

final class AddUserViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var gender = Gender.unknown
    @Published var birthday = Date()
    private var onAdd: (User) -> Void

    init(onAdd: @escaping (User) -> Void) {
        self.onAdd = onAdd
    }
    
    func addUser() {
        let user = User(name: name, gender: gender, birthday: birthday)
        onAdd(user)
    }
}
