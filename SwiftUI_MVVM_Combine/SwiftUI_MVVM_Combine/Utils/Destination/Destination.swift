//
//  Destination.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import SwiftUI

enum Destination: Hashable, Equatable {
    
    case tabbar
    case main(viewModel: MainViewModel)
    case login(viewModel: LoginViewModel)
    case repoList(viewModel: RepoListViewModel)
    
    var view: AnyView {
        switch self {
        case .main(viewModel: let viewModel):
            return MainView(viewModel: viewModel).toAnyView()
        case .login(viewModel: let viewModel):
            return LoginView(viewModel: viewModel).toAnyView()
        case .tabbar:
            return TabarView().toAnyView()
        case .repoList(viewModel: let viewModel):
            return RepoListView(viewModel: viewModel).toAnyView()
        }
    }
}

extension Destination {
    
    private var id: String { UUID().uuidString }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
