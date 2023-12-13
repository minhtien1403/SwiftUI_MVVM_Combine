//
//  RepoListView.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 01/12/2023.
//

import SwiftUI

struct RepoListView: View {
    
    @EnvironmentObject private var navigator: Navigator
    @ObservedObject private var viewModel: RepoListViewModel
    
    init(viewModel: RepoListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        BaseView(content: {
            content
        }, error: viewModel.error)
        .navigationTitle("Repo List")
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .isLoading:
            loadingView()
        case .loaded, .loadingMore, .reloading:
            listView()
        case .errorLoaded:
            listView().onAppear(perform: {
                navigator.presentAlert()
            })
        }
    }
    
    @ViewBuilder
    func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .onAppear {
                viewModel.loadData()
            }
    }
    
    @ViewBuilder
    func listView() -> some View {
        List {
            ForEach(viewModel.repos) { repo in
                RepoView(repo: repo)
                    .onTapGesture {
                        navigator.push(to: .repoDetails(viewModel: RepoDetailsViewModel(repo: repo)))
                    }
            }
            
            if viewModel.state == .loadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .id(UUID()) // progress view only display one time without set uuid
            } else {
                Color.clear
                    .listRowSeparator(.hidden)
                    .padding()
                    .onAppear(perform: {
                        viewModel.loadMoreData()
                    })
            }
        }
        .refreshable {
            viewModel.refreshData()
        }
    }
}

//#Preview {
//    RepoListView(viewModel: RepoListViewModel())
//}
