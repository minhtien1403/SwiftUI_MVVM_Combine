//
//  APIRouter.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import Foundation

private struct APIRouter {
    
    struct getRepos: Request {
        
        var path: String = "/search/repositories"
        var queryParams: [String : Any]?
        
        init(queryParams: APIParameters.GetRepoParam) {
            self.queryParams = queryParams.asDictionary
        }
    }
    
    struct getEvents: Request {
        
        var baseURL: String
        var path: String = ""
        var queryParams: [String : Any]?
        
        init(baseURL: String, queryParams: APIParameters.GetEventParam) {
            self.baseURL = baseURL
            self.queryParams = queryParams.asDictionary
        }
    }
}

enum Router {
    
    case getRepos(queryParams: APIParameters.GetRepoParam)
    case getEvents(urlString: String, queryParams: APIParameters.GetEventParam)
    
    var request: any Request {
         
        switch self {
        case .getRepos(queryParams: let param):
            return APIRouter.getRepos(queryParams: param)
        case .getEvents(urlString: let urlString, queryParams: let param):
            return APIRouter.getEvents(baseURL: urlString, queryParams: param)
        }
    }
}
