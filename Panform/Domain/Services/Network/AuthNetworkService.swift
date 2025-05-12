//
//  AuthNetworkService.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import FirebaseAuth
import FirebaseStorage

protocol AuthNetworkServiceProtocol {
    var currentUser: User? { get }
    var currentPanformUserID: UserID? { get }
    func getCurrentPanformUser(completionHandler: @escaping (UserModel?) -> Void)
    func signUp(email: String,
                password: String,
                completionHandler: @escaping (Result<String, Error>) -> Void)
    func login(email: String,
               password: String,
               completionHandler: @escaping (Result<Void, Error>) -> Void)
    func logout()
    func updateUserInfo(id: String,
                        name: String,
                        description: String,
                        avatarURL: String,
                        completionHandler: @escaping (Result<Void, Error>) -> Void)
    func createUserInfo(uid: String,
                        email: String,
                        name: String,
                        completionHandler: @escaping (Result<Void, Error>) -> Void)
    func uploadProfileImage(of userID: UserID,
                            imageData: Data,
                            completion: @escaping (URL) -> Void)
}

final class AuthNetworkService {
    static let shared = AuthNetworkService()
    private let auth: Auth
    private let storage: Storage
    private let apolloClient: GraphQLClient
    private var _currentPanformUserID: UserID?

    private init(auth: Auth = Auth.auth(),
                 apolloClient: GraphQLClient = GraphQLClient.shared,
                 storage: Storage = Storage.storage()) {
        self.auth = auth
        self.apolloClient = apolloClient
        self.storage = storage
        getCurrentPanformUser { [weak self] user in
            self?._currentPanformUserID = user?.id
        }
    }
}

extension AuthNetworkService: AuthNetworkServiceProtocol {
    var currentUser: User? {
        return auth.currentUser
    }

    var currentPanformUserID: UserID? {
        return _currentPanformUserID
    }

    func getCurrentPanformUser(completionHandler: @escaping (UserModel?) -> Void) {
        if let uid = auth.currentUser?.uid {
            apolloClient.apollo.fetch(query: Panform.GetCurrentUserInfoQuery(uid: uid),
                                      cachePolicy: .fetchIgnoringCacheCompletely) {result in
                guard let user = try? result.get().data?.users.first else { return }
                if let userID = UUID(uuidString: user.id) {
                    completionHandler(UserModel(id: userID,
                                                name: user.name,
                                                email: user.email,
                                                description: user.description,
                                                avatarURL: URL(string: user.avatarUrl ?? "")))
                } else {
                    completionHandler(nil)
                }
            }
        }
    }

    func signUp(email: String,
                password: String,
                completionHandler: @escaping (Result<String, Error>) -> Void) {
        auth.createUser(withEmail: email,
                        password: password) { result, error in
            if let error {
                completionHandler(.failure(error))
            } else if let uid = result?.user.uid {
                completionHandler(.success(uid))
            } else {
                completionHandler(.failure(NSError()))
            }
        }
    }

    func login(email: String,
               password: String,
               completionHandler: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email,
                    password: password) { result, error in
            if let error {
                completionHandler(.failure(error))
            } else {
                completionHandler(.success(()))
            }
        }
    }

    func logout() {
        try? auth.signOut()
        _currentPanformUserID = nil
    }

    func updateUserInfo(id: String,
                        name: String,
                        description: String,
                        avatarURL: String,
                        completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let mutation = Panform.EditProfileMutation(name: name,
                                                   id: id,
                                                   description: description,
                                                   avatarUrl: avatarURL)
        apolloClient.apollo.perform(mutation: mutation) { [weak self] result in
            switch result {
                case .success(let graphQLResult):
                if graphQLResult.data?.update_users_by_pk?.id != nil,
                   let userID = UUID(uuidString: id) {
                        self?._currentPanformUserID = userID
                        completionHandler(.success(()))
                    } else if let error = graphQLResult.errors?.first {
                        completionHandler(.failure(error))
                    } else {
                        completionHandler(.failure(NSError()))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }

    func createUserInfo(uid: String,
                        email: String,
                        name: String,
                        completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let mutation = Panform.InsertUserInfoMutation(
            avatarUrl: .null,
            description: "",
            email: email,
            name: name,
            uid: uid
        )
        apolloClient.apollo.perform(mutation: mutation) { [weak self] result in
            switch result {
                case .success(let graphQLResult):
                    if let id = graphQLResult.data?.insert_users_one?.id,
                       let userID = UUID(uuidString: id) {
                        self?._currentPanformUserID = userID
                        completionHandler(.success(()))
                    } else if let error = graphQLResult.errors?.first {
                        completionHandler(.failure(error))
                    } else {
                        completionHandler(.failure(NSError()))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }

    func uploadProfileImage(of userID: UserID,
                            imageData: Data,
                            completion: @escaping (URL) -> Void) {
        let imageRef = storage.reference().child("profile_images/\(userID).jpg")

        imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                print("Failed to upload image: \(error!)")
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let url else { return }
                completion(url)
            }
        }
    }
}
