//
//  AddUserView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 05/12/2023.
//

import SwiftUI

struct AddUserView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @FocusState private var focusedField: Field?
    @ObservedObject private var viewModel: AddUserViewModel
    
    init(onAdd: @escaping (User) -> Void) {
        viewModel = AddUserViewModel(onAdd: onAdd)
    }
    
    private enum Field: Hashable {
        case name
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.name)
                .focused($focusedField, equals: .name)
                .task {
                    try? await Task.sleep(nanoseconds: 600_000_000)  // 0.5s
                    focusedField = .name
                }
            
            Picker("Gender", selection: $viewModel.gender) {
                ForEach(Gender.allCases) { gender in
                    Text(gender.title)
                        .tag(gender)
                }
            }
            
            DatePicker("Birthday", selection: $viewModel.birthday, displayedComponents: .date)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    navigator.dismissSheet()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    viewModel.addUser()
                    navigator.dismissSheet()
                }
                .disabled(viewModel.name.isEmpty)
            }
        }
    }
}

//#Preview {
//    AddUserView()
//}
