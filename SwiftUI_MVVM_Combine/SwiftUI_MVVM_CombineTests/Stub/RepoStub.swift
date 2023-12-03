//
//  RepoStub.swift
//  SwiftUI_MVVM_CombineTests
//
//  Created by tientm on 02/12/2023.
//

import Foundation
@testable import SwiftUI_MVVM_Combine

extension Repo {
    static let stub = Repo(
        id: 1,
        name: "Repo 1",
        fullName: "Repo 1",
        url: "",
        eventUrl: "",
        stars: 1,
        forks: 1,
        owner: nil
    )
}

extension GetReposResult {
    
    static let stub = GetReposResult(items: [Repo.stub])
}
