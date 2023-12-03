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
        var per_page: Int
        var page: Int
    }
    
    struct GetEventParam: Encodable {
        
        var page: Int
        var per_page: Int
    }
}
