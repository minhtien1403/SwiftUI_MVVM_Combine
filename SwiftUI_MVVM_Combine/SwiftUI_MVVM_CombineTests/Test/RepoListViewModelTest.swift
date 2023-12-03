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
        Container.shared.repoServices.register {
            self.repoServicesMock
        }
    }
    
    override func tearDown() {
        repoServicesMock = nil
    }
    
    func testLoadRepoSuccess() {
        // Prepare mock context for testing
        let vm = RepoListViewModel()
        let result = GetReposResult.stub
        repoServicesMock.getReposResult = Just(result).setFailureType(to: NetworkRequestError.self).eraseToAnyPublisher()
        // Excute test action
        vm.loadData()
        // Expected result
        XCTAssert(vm.repos.count == result.items.count)
        XCTAssert(vm.state == .loaded)
    }
    
    func testLoadRepoFailure() {
        let vm = RepoListViewModel()
        let mockError = NetworkRequestError.forbidden
        repoServicesMock.getReposResult = Fail(error: mockError).eraseToAnyPublisher()
        // Excute test action
        vm.loadData()
        // Expected result
        XCTAssert(vm.error == mockError)
        XCTAssert(vm.state == .errorLoaded)
    }
    
    func testLoadmoreRepoSuccess() {
        // Prepare mock context for testing
        let vm = RepoListViewModel()
        let result = GetReposResult.stub
        repoServicesMock.getReposResult = Just(result).setFailureType(to: NetworkRequestError.self).eraseToAnyPublisher()
        let currentPage = vm.page
        let currentRepoCount = vm.repos.count
        vm.state = .loaded
        // Excute test action
        vm.loadMoreData()
        // Expected result
        XCTAssert(vm.repos.count == result.items.count + currentRepoCount)
        XCTAssert(vm.page == currentPage + 1)
        XCTAssert(vm.state == .loaded)
    }
    
    func testLoadmoreRepoFailure() {
        let vm = RepoListViewModel()
        let currentPage = vm.page
        let currentRepoCount = vm.repos.count
        let mockError = NetworkRequestError.forbidden
        repoServicesMock.getReposResult = Fail(error: mockError).eraseToAnyPublisher()
        vm.state = .loaded
        // Excute test action
        vm.loadMoreData()
        // Expected result
        XCTAssert(vm.repos.count == currentRepoCount)
        XCTAssert(vm.page == currentPage)
        XCTAssert(vm.state == .errorLoaded)
        XCTAssert(vm.error == mockError)
    }
    
    func testLoadingMoreRepoWhenViewIsLoading() {
        let vm = RepoListViewModel()
        let result = GetReposResult.stub
        repoServicesMock.getReposResult = Just(result).setFailureType(to: NetworkRequestError.self).eraseToAnyPublisher()
        let currentPage = vm.page
        let currentRepoCount = vm.repos.count
        vm.state = .isLoading
        // Excute test action
        vm.loadMoreData()
        // Expected result
        XCTAssert(vm.repos.count == currentRepoCount)
        XCTAssert(vm.page == currentPage)
        XCTAssert(vm.state == .isLoading)
    }
    
    func testRefreshDataSucesss() {
        // Prepare mock context for testing
        let vm = RepoListViewModel()
        let result = GetReposResult.stub
        repoServicesMock.getReposResult = Just(result).setFailureType(to: NetworkRequestError.self).eraseToAnyPublisher()
        vm.state = .loaded
        vm.page = 3
        // Excute test action
        vm.refreshData()
        // Expected result
        XCTAssert(vm.page == 1)
    }
    
    func testRefreshDataFail() {
        // Prepare mock context for testing
        let vm = RepoListViewModel()
        let result = GetReposResult.stub
        repoServicesMock.getReposResult = Just(result).setFailureType(to: NetworkRequestError.self).eraseToAnyPublisher()
        vm.state = .isLoading
        vm.page = 3
        // Excute test action
        vm.refreshData()
        // Expected result
        XCTAssert(vm.page == 3)
    }
}
