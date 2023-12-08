//
//  User.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 03/12/2023.
//

import Foundation

enum Gender: Int, Identifiable, CaseIterable {
    case unknown = 0
    case male = 1
    case female = 2
    
    var title: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        default:
            return "Unknown"
        }
    }
    
    var id: Int { rawValue }
}

struct User: Identifiable {
    
    var id = UUID().uuidString
    var name = ""
    var gender = Gender.unknown
    var birthday = Date()
}

extension User {
    init?(entity: CDUser) {
        guard let id = entity.id else {
            return nil
        }
        
        self.id = id
        self.name = entity.name ?? ""
        self.gender = Gender(rawValue: Int(entity.gender)) ?? .unknown
        self.birthday = entity.birthday ?? Date()
    }
    
    func map(to entity: CDUser) {
        entity.id = self.id
        entity.name = self.name
        entity.gender = Int64(self.gender.rawValue)
        entity.birthday = self.birthday
    }
}

extension User: Equatable {
    
}
