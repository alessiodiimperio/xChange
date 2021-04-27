//
//  ServiceAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-08.
//
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import Swinject

final class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleServices(container)
    }
        
    private func assembleServices(_ container: Container) {
        assembleFirebase(container)
        assembleAuthenticationProvider(container)
        assembleDataProvider(container)
        assembleFavoritesProvider(container)
        assembleChatProvider(container)
        assembleFeedProvider(container)
    }
    
    private func assembleFirebase(_ container: Container){
        container.register(Auth.self){_ in
            Auth.auth()
        }
        
        container.register(Firestore.self){_ in
            Firestore.firestore()
        }
        
        container.register(Storage.self) {_ in
            FirebaseStorage.Storage.storage()
        }
    }
    
    private func assembleAuthenticationProvider(_ container: Container){
        container.register(AuthenticationProvider.self){r in
            let firestore = r.resolve(Firestore.self)!
            return FirebaseAuthProvider(firestore: firestore)
        }.inObjectScope(.container)
    }
    
    private func assembleDataProvider(_ container: Container) {
        container.register(DataProvider.self){r in
            let auth = r.resolve(AuthenticationProvider.self)!
            let firestore = r.resolve(Firestore.self)!
            let storage = r.resolve(Storage.self)!
            return FirestoreDataProvider(auth: auth,
                                         firestore: firestore,
                                         storage: storage)
        }.inObjectScope(.container)
    }
   
    private func assembleFavoritesProvider(_ container: Container) {
        container.register(FavoritesProvider.self) {r in
            let auth = r.resolve(AuthenticationProvider.self)!
            let firestore = r.resolve(Firestore.self)!
            return FirebaseFavouriteProvider(auth: auth, firestore: firestore)
        }
    }
    
    private func assembleChatProvider(_ container: Container) {
        container.register(ChatProvider.self){r in
            let auth = r.resolve(AuthenticationProvider.self)!
            let firestore = Firestore.firestore()
            return FirebaseChatProvider(auth: auth,
                                 firestore: firestore)
        }
    }
    
    private func assembleFeedProvider(_ container: Container){
        container.register(FeedProvider.self) { r in
            let auth = r.resolve(AuthenticationProvider.self)!
            let firestore = r.resolve(Firestore.self)!
            return FirebaseFeedProvider(auth: auth, firestore: firestore)
        }
    }
}
