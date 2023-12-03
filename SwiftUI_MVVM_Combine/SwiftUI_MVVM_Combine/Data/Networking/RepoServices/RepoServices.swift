//
//  RepoServices.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import Combine
import Factory

protocol RepoServicesProtocol {
    
    func getRepos(queryParams: APIParameters.GetRepoParam) -> AnyPublisher<GetReposResult, NetworkRequestError>
    func getEvents(urlString: String, queryParams: APIParameters.GetEventParam) -> AnyPublisher<[Event], NetworkRequestError>
}

final class RepoServices: RepoServicesProtocol {
    
    private let apiServices = APIServices.shared
    
    func getRepos(queryParams: APIParameters.GetRepoParam) -> AnyPublisher<GetReposResult, NetworkRequestError> {
        apiServices.request(route: .getRepos(queryParams: queryParams))
    }
    
    func getEvents(urlString: String, queryParams: APIParameters.GetEventParam) -> AnyPublisher<[Event], NetworkRequestError> {
        apiServices.request(route: .getEvents(urlString: urlString, queryParams: queryParams))
    }
}

extension Container {
    
    var repoServices: Factory<RepoServicesProtocol> {
        Factory(self) { RepoServices() }
            .singleton
    }
}
