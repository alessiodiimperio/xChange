//
//  FirebaseUserAuth.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import Firebase
import RxSwift

struct FirebaseAuthProvider:AuthenticationProvider {
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
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
                try db.collection(FirestoreCollection.users.path)
                    .document(data.user.uid).setData(from: User(id: data.user.uid,
                                                                username: username))
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
}
