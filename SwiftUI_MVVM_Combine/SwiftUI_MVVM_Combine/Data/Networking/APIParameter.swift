//
//  APIParameter.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import Foundation

struct APIParameters {
    
    struct GetRepoParam: Encodable {
        
        var q: String = "language:swift"
        var perPage: Int
        var page: Int
        
        private enum CodingKeys: String, CodingKey {
            case perPage = "per_page"
            case q, page
        }
    }
    
    struct GetEventParam: Encodable {
        
        var page: Int
        var perPage: Int
        
        private enum CodingKeys: String, CodingKey {
            case perPage = "per_page"
            case page
        }
    }
}
