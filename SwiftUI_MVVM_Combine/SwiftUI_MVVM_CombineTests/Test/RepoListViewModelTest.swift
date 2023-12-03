//
//  RepoListViewModelTest.swift
//  SwiftUI_MVVM_CombineTests
//
//  Created by tientm on 02/12/2023.
//

import XCTest
import Combine
import Factory
@testable import SwiftUI_MVVM_Combine

class RepoListViewModelTest: XCTestCase {
    
    var repoServicesMock: RepoServicesMock!
            
    override func setUp() {
        super.setUp()
        repoServicesMock = RepoServicesMock()
    }
    
    override func tearDown() {
        repoServicesMock = nil
    }
    
    func testLoadRepoSuccess() {
        // Prepare mock context for testing
        Container.shared.repoServices.register {
            self.repoServicesMock
        }
        let result = GetReposResult.stub
        repoServicesMock.getReposResult = Just(result).setFailureType(to: NetworkRequestError.self).eraseToAnyPublisher()
        // Excute test action
        let vm = RepoListViewModel()
        vm.loadData()
        // Expected result
        XCTAssert(vm.repos.count == result.items.count)
        XCTAssert(vm.state == .loaded)
    }
    
    func testLoadRepoFailure() {
        Container.shared.repoServices.register {
            self.repoServicesMock
        }
        let mockError = NetworkRequestError.forbidden
        repoServicesMock.getReposResult = Fail(error: mockError).eraseToAnyPublisher()
        // Excute test action
        let vm = RepoListViewModel()
        vm.loadData()
        // Expected result
        XCTAssert(vm.error == mockError)
        XCTAssert(vm.state == .errorLoaded)
    }
    
    func testLoadmoreRepoSuccess() {
        
    }
    
    func testLoadmoreRepoFailure() {
        
    }
}
