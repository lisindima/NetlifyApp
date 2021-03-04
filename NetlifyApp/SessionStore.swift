//
//  SessionStore.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation
import Combine

class SessionStore: ObservableObject {
    @Published var sitesLoadingState: LoadingState<[Site]> = .loading
    
    static let shared = SessionStore()
    
    func getCurrentUser() {
        Endpoint.api.fetch(.user) { (result: Result<User, ApiError>) in
            switch result {
            case let .success(value):
                print(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func listSites() {
        Endpoint.api.fetch(.sites) { [self] (result: Result<[Site], ApiError>) in
            switch result {
            case let .success(value):
                if value.isEmpty {
                    sitesLoadingState = .empty
                } else {
                    sitesLoadingState = .success(value)
                }
            case let .failure(error):
                sitesLoadingState = .failure(error)
            }
        }
    }
}
