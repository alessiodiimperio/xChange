//
//  Authenticator.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//
import Firebase

protocol AuthenticationProvider{
    func isSignedIn()->Bool
    func currentUserID()->String?
    func signIn(with credentials:Credential, completion: @escaping (_ result:Result<Bool,Error>) -> Void)
    func createUser(email:String, password:String, username:String, completion: @escaping (_ error:Error?)->Void)
    func requestPasswordReset(for email:String, completion: @escaping (_ error:Error?)->Void)
    func signOut()
}
