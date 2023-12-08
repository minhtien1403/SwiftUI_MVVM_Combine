//
//  UserListViewModel.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 03/12/2023.
//

import Foundation
import Combine

final class UserListViewModel: ObservableObject {
    
    enum UserListViewState {
        
        case isLoading ,errorLoaded, loaded
    }
    
    private var userService: UserServicesProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var users = [User]()
    @Published var state = UserListViewState.isLoading
    @Published var error: CoreDataError?
    @Published var selectedUser: User?
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    init(userService: UserServicesProtocol = UserServices.shared) {
        self.userService = userService
    }
    
    private func handleFailure() -> ((Subscribers.Completion<CoreDataError>) -> Void) {
        return { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
                self.state = .errorLoaded
            }
        }
    }
    
    func loadUser() {
        userService.getAllUser()
            .sink(receiveCompletion: handleFailure(), receiveValue: { users in
                self.users = users
                self.state = .loaded
            })
            .store(in: &cancellableSet)
    }
    
    func addUser(user: User) {
        userService.addNewUser(user: user)
            .sink(receiveCompletion: handleFailure(), receiveValue: { _ in
                self.loadUser()
            })
            .store(in: &cancellableSet)
    }
    
    func deleteUser(at offSet: IndexSet) {
        let index = offSet[offSet.startIndex]
        let user = users[index]
        userService.delete(byID: user.id)
            .sink(receiveCompletion: handleFailure()) { _ in
                self.loadUser()
                self.users.removeAll { $0.id == user.id }
            }
            .store(in: &cancellableSet)
    }
    
    func updateUser(user: User) {
        userService.update(user)
            .sink(receiveCompletion: handleFailure()) { _ in
                self.loadUser()
            }
            .store(in: &cancellableSet)
    }
}
