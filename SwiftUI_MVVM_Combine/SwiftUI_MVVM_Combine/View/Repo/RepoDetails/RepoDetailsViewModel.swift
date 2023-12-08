//
//  RepoDetailsViewModel.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 03/12/2023.
//

import Foundation
import Factory
import Combine

final class RepoDetailsViewModel: ObservableObject {
    
    enum RepoDetailsViewState {
        case isLoading, loaded, loadingMore, reloading, errorLoaded
    }
    
    @Injected(\.repoServices) var repoServices: RepoServicesProtocol
    @Published var events: [Event] = []
    @Published var page = 1
    @Published var state: RepoDetailsViewState = .isLoading
    @Published var error: NetworkRequestError?
    let repo: Repo
    private let perPage = 20
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(repo: Repo) {
        self.repo = repo
    }
        
    func loadEvent() {
        repoServices.getEvents(urlString: repo.eventUrl, queryParams: APIParameters.GetEventParam(page: page, per_page: perPage))
            .sink { complete in
                switch complete {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                    self.state = .errorLoaded
                }
            } receiveValue: { events in
                self.events = events
                self.state = .loaded
            }
            .store(in: &cancellableSet)

    }
    
    func loadMoreEvent() {
        guard state == .loaded else { return }
        state = .loadingMore
        repoServices.getEvents(urlString: repo.eventUrl, queryParams: APIParameters.GetEventParam(page: page + 1, per_page: perPage))
            .sink { complete in
                switch complete {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                    self.state = .errorLoaded
                }
            } receiveValue: { events in
                self.events += events
                self.page += 1
                self.state = .loaded
            }
            .store(in: &cancellableSet)
    }
    
    func reloadEvent() {
        guard state == .loaded else { return }
        page = 1
        state = .reloading
        loadEvent()
    }
}
