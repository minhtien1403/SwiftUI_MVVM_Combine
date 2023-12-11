//
//  RepoListViewModel.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 01/12/2023.
//

import Foundation
import Combine
import Factory

final class RepoListViewModel: ObservableObject {
    
    enum RepoListViewState {
        case isLoading, loaded, loadingMore, reloading, errorLoaded
    }
    
    @Injected(\.repoServices) var repoServices: RepoServicesProtocol
    @Published var repos: [Repo] = []
    @Published var page = 1
    @Published var state: RepoListViewState = .isLoading
    @Published var error: NetworkRequestError?
    private let perPage = 20
    private var cancellableSet: Set<AnyCancellable> = []

    
    func loadData() {
        repoServices.getRepos(queryParams: APIParameters.GetRepoParam(perPage: perPage, page: page))
            .sink { complete in
                switch complete {
                case.finished:
                    Log.info("Get Repo Success")
                case .failure(let error):
                    Log.error("Get Repo Error: \(error.localizedDescription)")
                    self.error = error
                    self.state = .errorLoaded
                }
            } receiveValue: { repos in
                self.repos = repos.items
                self.state = .loaded
                print(repos)
            }
            .store(in: &cancellableSet)
    }
    
    func loadMoreData() {
        guard state == .loaded else {
            return
        }
        state = .loadingMore
        repoServices.getRepos(queryParams: APIParameters.GetRepoParam(perPage: perPage, page: page + 1))
            .sink { complete in
                switch complete {
                case .finished:
                    Log.info("Load more repo success")
                case .failure( let error):
                    Log.error("Load more repo error: \(error.localizedDescription)")
                    self.state = .errorLoaded
                    self.error = error
                }
            } receiveValue: { repos in
                self.state = .loaded
                self.repos.append(contentsOf: repos.items)
                self.page += 1
            }
            .store(in: &cancellableSet)

    }
    
    func refreshData() {
        guard state == .loaded else { return }
        page = 1
        state = .reloading
        loadData()
    }
}
