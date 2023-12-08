//
//  SwiftUIView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 08/12/2023.
//

import SwiftUI

struct EditUserView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var viewModel: EditUserViewModel
    @FocusState private var focusedField: Field?
    
    init(viewModel: EditUserViewModel) {
        self.viewModel = viewModel
    }
    
    private enum Field: Hashable {
        case name
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.user.name)
                .focused($focusedField, equals: .name)
                .task {
                    try? await Task.sleep(nanoseconds: 600_000_000)  // 0.5s
                    focusedField = .name
                }
                .submitLabel(.done)
                .onSubmit {
                    viewModel.updateUser()
                }
            
            Picker("Gender", selection: $viewModel.user.gender) {
                ForEach(Gender.allCases) { gender in
                    Text(gender.title)
                        .tag(gender)
                }
            }
            
            DatePicker("Birthday", selection: $viewModel.user.birthday, displayedComponents: .date)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    navigator.dismissSheet()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Update") {
                    viewModel.updateUser()
                    navigator.dismissSheet()
                }
                .disabled(viewModel.user.name.isEmpty)
            }
        }
    }
}

//#Preview {
//    SwiftUIView()
//}
