//
//  UserServices.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 03/12/2023.
//

import CoreData
import Combine

protocol UserServicesProtocol {
    
    func addNewUser(user: User) -> AnyPublisher<Void, CoreDataError>
    func getAllUser() -> AnyPublisher<[User], CoreDataError>
    func delete(byID id: String) -> AnyPublisher<User?, CoreDataError>
    func update(_ user: User) -> AnyPublisher<Void, CoreDataError>
}

final class UserServices: UserServicesProtocol {
    
    private let viewContext = PersistenceController.shared.container.viewContext
    static let shared = UserServices()
        
    private init() {}
    
    func addNewUser(user: User) -> AnyPublisher<Void, CoreDataError> {
        return Future<Void, CoreDataError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(CoreDataError.selfDeallocated))
                return
            }
            let newCDUser = CDUser(context: viewContext)
            user.map(to: newCDUser)
            do {
                try viewContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getAllUser() -> AnyPublisher<[User], CoreDataError> {
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        
        return Future<[User], CoreDataError> { promise in
            do {
                let cdUsers = try self.viewContext.fetch(fetchRequest)
                let users = cdUsers.compactMap { User(entity: $0) }
                promise(.success(users))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(byID id: String) -> AnyPublisher<User?, CoreDataError> {
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        return Future<User?, CoreDataError> { promise in
            do {
                let cdUsers = try self.viewContext.fetch(fetchRequest)
                guard let cdUser = cdUsers.first else {
                    promise(.success(nil)) // User not found
                    return
                }
                let deletedUser = User(entity: cdUser) // Keep a reference to the deleted user
                self.viewContext.delete(cdUser)
                try self.viewContext.save()
                promise(.success(deletedUser))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(_ user: User) -> AnyPublisher<Void, CoreDataError> {
        return Future<Void, CoreDataError> { promise in
            do {
                let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", user.id)
                let cdUsers = try self.viewContext.fetch(fetchRequest)
                guard let cdUser = cdUsers.first else {
                    // Handle the case where the user with the specified ID is not found.
                    promise(.failure(CoreDataError.userNotFound))
                    return
                }
                // Update the CDUser with values from the User model
                user.map(to: cdUser)
                try self.viewContext.save()
                promise(.success(()))
            } catch {
                promise(.failure(CoreDataError.saveError(error)))
            }
        }
        .eraseToAnyPublisher()
    }
}
