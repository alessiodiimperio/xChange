//
//  FirebaseUserAuth.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa

struct FirebaseAuthProvider:AuthenticationProvider {
    let auth = Auth.auth()
    let firestore: Firestore
    let currentUser = BehaviorRelay<User?>(value: nil)
    
    init(firestore: Firestore){
        self.firestore = firestore
        
        if let _ = auth.currentUser {
            fetchCurrentUserData()
        }
    }
    
    func isSignedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func currentUserID() -> String? {
        return auth.currentUser?.uid
    }
    
    func signIn(with credentials:Credential, completion: @escaping (Result<Bool,Error>) -> Void) {
        auth.signIn(withEmail: credentials.email, password: credentials.password) { (data, error) in
            if(error != nil){
                completion(.failure(error!))
                return
            }
            if let userId = data?.user.uid {
                getUser(for: userId)  { user in
                    currentUser.accept(user)
                }
            }
            completion(.success(true))
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print(error)
        }
    }
    
    func createUser(email: String, password: String, username: String, completion: @escaping (_ error:Error?) -> Void) {
        auth.createUser(withEmail: email, password: password){ data, error in
            guard let data = data else { return }
            
            do {
                let user = User(id: data.user.uid,
                                username: username,
                                email: email)
                
                try firestore.collection(FirestoreCollection.users.path)
                    .document(data.user.uid).setData(from: user)
                
                currentUser.accept(user)
            } catch {
                print(error.localizedDescription)
            }
            completion(error)
        }
    }
    
    func requestPasswordReset(for email:String, completion: @escaping (_ error:Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email){ error in
            completion(error)
        }
    }
    
    private func fetchCurrentUserData(){
        guard let user = auth.currentUser else { return }
        getUser(for: user.uid) { user in
            if let user = user {
                currentUser.accept(user)
            }
        }
    }
    
    func getUser(for userId: String, completion: @escaping (User?) -> Void) {
        firestore.collection(FirestoreCollection.users.path).document(userId).getDocument { (doc, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
    
            if let user = try? doc?.data(as: User.self) {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
}
