//
//  MainView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView(content: {
            List {
                Section("Repo - API") {
                    HStack(content: {
                        Text("Repo List")
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                    .contentShape(Rectangle())
                    .onTapGesture {
                        navigator.push(to: .repoList(viewModel: RepoListViewModel()))
                    }
                }
                Section("User - CoreData") {
                    HStack(content: {
                        Text("User List")
                        Spacer()
                        Image(systemName: "chevron.right")
                    })
                    .contentShape(Rectangle())
                    .onTapGesture {
                        navigator.push(to: .userList(viewModel: UserListViewModel()))
                    }
                }
                .onTapGesture {
                    // navigate to user list
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        })
        
    }
}

#Preview {
    MainView(viewModel: MainViewModel())
}
