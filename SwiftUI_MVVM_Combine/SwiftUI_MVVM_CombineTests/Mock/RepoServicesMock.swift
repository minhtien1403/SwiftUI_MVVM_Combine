//
//  RepoServicesMock.swift
//  SwiftUI_MVVM_CombineTests
//
//  Created by tientm on 02/12/2023.
//

import Combine
import Factory
@testable import SwiftUI_MVVM_Combine

final class RepoServicesMock: RepoServicesProtocol {
    
    var getReposResult: AnyPublisher<SwiftUI_MVVM_Combine.GetReposResult, SwiftUI_MVVM_Combine.NetworkRequestError>!
    var getEventsResult: AnyPublisher<[SwiftUI_MVVM_Combine.Event], SwiftUI_MVVM_Combine.NetworkRequestError>!
    
    func getRepos(queryParams: SwiftUI_MVVM_Combine.APIParameters.GetRepoParam) -> AnyPublisher<SwiftUI_MVVM_Combine.GetReposResult, SwiftUI_MVVM_Combine.NetworkRequestError> {
        print("Repo Service Mock Running")
        return getReposResult
    }
    
    func getEvents(urlString: String, queryParams: SwiftUI_MVVM_Combine.APIParameters.GetEventParam) -> AnyPublisher<[SwiftUI_MVVM_Combine.Event], SwiftUI_MVVM_Combine.NetworkRequestError> {
        return getEventsResult
    }
}

extension Container {
    
    var repoServices: Factory<RepoServicesProtocol> {
        Factory(self) { RepoServicesMock() }
    }
}
