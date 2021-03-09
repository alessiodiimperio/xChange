//
//  ServiceAssembly.swift
//  xChange
//
//  Created by Alessio on 2021-03-08.
//
import Swinject

final class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        assembleServices(container)
    }
        
    private func assembleServices(_ container: Container) {
        assembleAuthenticationProvider(container)
        assembleDataProvider(container)
        assembleFavoritesProvider(container)
        assembleFeedProvider(container)
    }
    
    private func assembleAuthenticationProvider(_ container: Container){
        container.register(AuthenticationProvider.self){_ in
            return FirebaseAuthProvider()
        }.inObjectScope(.container)
    }
    
    private func assembleDataProvider(_ container: Container) {
        container.register(DataProvider.self){r in
            let auth = r.resolve(AuthenticationProvider.self)
            return FirestoreDataProvider(auth: auth!)
        }.inObjectScope(.container)
    }
   
    private func assembleFavoritesProvider(_ container: Container) {
        container.register(FavoritesProvider.self) {r in
            let auth = r.resolve(AuthenticationProvider.self)!
            return FirebaseFavouriteProvider(auth: auth)
        }
    }
    
    private func assembleFeedProvider(_ container: Container){
        container.register(FeedProvider.self) { r in
            let auth = r.resolve(AuthenticationProvider.self)!
            return FirebaseFeedProvider(auth: auth)
        }
    }
}
