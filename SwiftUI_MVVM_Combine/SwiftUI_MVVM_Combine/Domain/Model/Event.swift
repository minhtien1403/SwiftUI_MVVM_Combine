//
//  Event.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import Foundation

struct Event: Codable {
    enum EventType: String, Codable {
        case fork = "ForkEvent"
        case watch = "WatchEvent"
        case issues = "IssuesEvent"
        case issueComment = "IssueCommentEvent"
        case pullRequest = "PullRequestEvent"
        case other
        
        var name: String {
            switch self {
            case .fork:
                return "Fork"
            case .watch:
                return "Watch"
            case .issues:
                return "Issues"
            case .issueComment:
                return "Issue Comment"
            case .pullRequest:
                return "Pull Request"
            case .other:
                return "Other"
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawString = try container.decode(String.self)
            self = EventType(rawValue: rawString) ?? .other
        }
    }
    
    var id = ""
    var type = EventType.fork
    var actor: Repo.Owner?
}

extension Event: Identifiable, Equatable { }

