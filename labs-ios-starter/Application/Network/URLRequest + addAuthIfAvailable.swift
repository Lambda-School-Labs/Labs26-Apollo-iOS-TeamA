//
//  URLRequest + addAuthIfAvailable.swift
//  labs-ios-starter
//
//  Created by Kenny on 9/12/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

extension URLRequest {
    ///add the user's bearer token to a request
    mutating func addAuthIfAvailable() {
        guard let oktaCredentials = try? ProfileController.shared.oktaAuth.credentialsIfAvailable() else {
            return
        }
        
        self.addValue("Bearer \(oktaCredentials.idToken)", forHTTPHeaderField: NetworkService.HttpHeaderType.authorization.rawValue)
    }
}
