//
//  RepoUseCase.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 01/12/2023.
//

import Combine

protocol RepoUseCase {
    
    var repoServices: RepoServicesProtocol { get }
}

extension RepoUseCase {
    
    func getRepos(param: APIParameters.GetRepoParam) -> AnyPublisher<GetReposResult, NetworkRequestError> {
        repoServices.getRepos(queryParams: param)
    }
    
    func getEvents(urlString: String, param: APIParameters.GetEventParam) -> AnyPublisher<[Event], NetworkRequestError> {
        repoServices.getEvents(urlString: urlString, queryParams: param)
    }
}
