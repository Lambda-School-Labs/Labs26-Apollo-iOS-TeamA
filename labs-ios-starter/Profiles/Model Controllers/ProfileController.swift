//
//  ProfileController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

class ProfileController {
    // MARK: - Properties -
    let networkService = NetworkService.shared
    private(set) var authenticatedUserProfile: Member?
    private(set) var profiles: [Member] = []

    /// Apollo API base URL
    let baseURL = URL(string: "https://apollo-a-api.herokuapp.com")!
    /// Okta auth URL
    private let oktaAuthURL = URL(string: "https://dev-625244.okta.com/")!
    /// Callback URI
    let callbackURI = "labs://apollo/implicit/callback"

    /// Okta Auth Credentials
    lazy var oktaAuth = OktaAuth(baseURL: oktaAuthURL,
    clientID: "0oavsbe2kAVi9pJPx4x6",
    redirectURI: callbackURI)
    
    static let shared = ProfileController()
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshProfiles),
                                               name: .oktaAuthenticationSuccessful,
                                               object: nil)
    }
    
    @objc func refreshProfiles() {
        getAllProfiles()
    }
    
    func getAllProfiles(completion: @escaping (ErrorHandler.UserAuthError?) -> Void = { error in }) {
        
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to get profiles from API")
            DispatchQueue.main.async {
                completion(.noConnection)
            }
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("profiles")
        guard var request = networkService.createRequest(url: requestURL, method: .get) else {
            print("invalid request")
            completion(.noConnection)
            return
        }

        request.addValue("Bearer \(oktaCredentials.idToken)", forHTTPHeaderField: NetworkService.HttpHeaderType.authorization.rawValue)

        networkService.loadData(using: request) { result in
            switch result {
            case .success(let data):
                guard let profiles = self.networkService.decode(to: [Member].self,
                                                                data: data,
                                                                moc: CoreDataManager.shared.mainContext) else {
                    print("couldn't decode profiles")
                    completion(.noConnection)
                    return
                }

                DispatchQueue.main.async {
                    self.profiles = profiles
                    completion(nil)
                }

            case .failure(let error):
                print("error with web login: \(error)")
                completion(.noConnection)
            }
        }
    }
    
    func getAuthenticatedUserProfile(completion: @escaping () -> Void = { }) {
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to get authenticated user profile from API")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        guard let userID = oktaCredentials.userID else {
            NSLog("User ID is missing.")
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        getSingleProfile(userID) { (profile) in
            self.authenticatedUserProfile = profile
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func checkForExistingAuthenticatedUserProfile(completion: @escaping (Bool) -> Void) {
        getAuthenticatedUserProfile {
            completion(self.authenticatedUserProfile != nil)
        }
    }
    
    func getSingleProfile(testing: Bool = false, _ userID: String, completion: @escaping (Member?) -> Void) {
        
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to get profile from API")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }

        let requestURL = baseURL
            .appendingPathComponent("profile")
            .appendingPathComponent(userID)
        guard var request = networkService.createRequest(url: requestURL, method: .get) else {
            print("invalid request")
            return
        }
        
        request.addValue("Bearer \(oktaCredentials.idToken)", forHTTPHeaderField: "Authorization")

        networkService.loadData(using: request) { result in
            var fetchedProfile: Member?
            switch result {
            case .success(let data):
                fetchedProfile = self.networkService.decode(to: Member.self,
                                                            data: data,
                                                            moc: CoreDataManager.shared.mainContext)
                completion(fetchedProfile)
            case .failure(let error):
                print("error logging in to heroku backend: \(error)")
                completion(nil)
                return
            }

        }

    }
    
    func updateAuthenticatedUserProfile(_ profile: Member, with name: String, email: String, avatarURL: URL, completion: @escaping (Member?) -> Void) {
        
        var oktaCredentials: OktaCredentials
        
        do {
            oktaCredentials = try oktaAuth.credentialsIfAvailable()
        } catch {
            postAuthenticationExpiredNotification()
            NSLog("Credentials do not exist. Unable to get authenticated user profile from API")
            DispatchQueue.main.async {
                completion(profile)
            }
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent("profiles")
        
        guard var request = networkService.createRequest(url: requestURL, method: .put) else {
            print("invalid request")
            completion(nil)
            return
        }
        request.httpMethod = "PUT"
        request.addValue("Bearer \(oktaCredentials.idToken)", forHTTPHeaderField: "Authorization")
        request.encode(from: profile)

        networkService.loadData(using: request) { (result) in
            switch result {
            case .success(let data):

                self.authenticatedUserProfile = self.networkService.decode(to: ProfileWithMessage.self, data: data)?.profile
                completion(profile)

            case .failure(let error):
                print("Error authenticating on \(requestURL.absoluteString): \(error)")
                completion(nil)
            }
        }
    }

    
    func postAuthenticationExpiredNotification() {
        NotificationCenter.default.post(name: .oktaAuthenticationExpired, object: nil)
    }
}
