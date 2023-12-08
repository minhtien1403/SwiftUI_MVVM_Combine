//
//  UserListView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 03/12/2023.
//

import SwiftUI

struct UserListView: View {
    
    @ObservedObject private var viewModel: UserListViewModel
    @EnvironmentObject private var navigator: Navigator
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigator.presentSheet(sheet: .addUser(onAdd: { user in
                            viewModel.addUser(user: user)
                        }))
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            })
            .onAppear(perform: {
                viewModel.loadUser()
            })
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .isLoading:
            ProgressView()
                .progressViewStyle(.circular)
        case .loaded, .errorLoaded:
            userList
        }
    }
    
    @ViewBuilder
    private var userList: some View {
        if viewModel.users.isEmpty {
            VStack {
                Spacer()
                Text("No users")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Button {
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
        } else {
            List {
                ForEach(viewModel.users) { user in
                    UserView(user: user)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedUser = user
                            navigator.presentSheet(sheet: .editUser(user: user, onUpdate: { user in
                                viewModel.updateUser(user: user)
                            }))
                        }
                }
                .onDelete(perform: viewModel.deleteUser)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    UserListView(viewModel: UserListViewModel())
}
