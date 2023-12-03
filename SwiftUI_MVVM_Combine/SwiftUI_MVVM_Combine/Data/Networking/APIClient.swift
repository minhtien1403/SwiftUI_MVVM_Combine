//
//  APIClient.swift
//  SwiftUI_MVVM_Combine
//
//  Created by tientm on 30/11/2023.
//

import Foundation
import Combine

struct APIServices {
    
    static let shared = APIServices()
    private let urlSession: URLSession
    
    private init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForResource = 10
        sessionConfig.timeoutIntervalForRequest = 10
        urlSession = URLSession(configuration: sessionConfig)
    }
    
    func request<T: Codable>(route: Router) -> AnyPublisher<T, NetworkRequestError> {
        guard let request = route.request.buildRequest() else {
            return Fail(outputType: T.self,
                        failure: NetworkRequestError.badRequest).eraseToAnyPublisher()
        }
        return makeRequest(request: request)
    }
    
    private func makeRequest<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError> {
        print("[\(request.httpMethod?.uppercased() ?? "")] '\(request.url!)'")
        return urlSession
            .dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw httpError(0)
                }
                //Log Request result
                print("[\(response.statusCode)] '\(request.url!)'")
                Log.info("\(String(data: data, encoding: .utf8) ?? "")")
                if !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: ReturnType.self, decoder: JSONDecoder())
            .mapError({ error in
                Log.error("\(error)")
                return handleError(error)
            })
            .eraseToAnyPublisher()
    }
    
    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError(error.localizedDescription)
        case let urlError as URLError:
            if urlError.code == .timedOut {
                return .timeOut
            }
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }

}

enum NetworkRequestError: LocalizedError, Equatable {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError( _ description: String)
    case urlSessionFailed(_ error: URLError)
    case timeOut
    case unknownError
    
    public var errorDescription: String? {
        switch self {
        case .decodingError(_):
            return "decode error"
        case .forbidden:
            return "Error Code: 403 \n Forbidden"
        case .error4xx(let code):
            return "Error Code: \(code)"
        case .error5xx(let code):
            return "Error code: \(code)"
        default:
            return "unexpected errer"
        }
    }
}

extension NetworkRequestError: Identifiable {
    var id: String {
        UUID().uuidString
    }
}
