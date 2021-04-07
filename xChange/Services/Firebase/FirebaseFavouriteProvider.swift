//
//  FirebaseFavouriteProvider.swift
//  xChange
//
//  Created by Alessio on 2021-03-07.
//
import Firebase
import Foundation
import RxSwift
import RxCocoa

class FirebaseFavouriteProvider: FavoritesProvider {
    
    private let auth:AuthenticationProvider
    private let firestore: Firestore
    
    private var favoriteSubscription: ListenerRegistration?
    let favoriteXChanges = BehaviorRelay<[XChange]?>(value: nil)
    
    init(auth: AuthenticationProvider, firestore: Firestore) {
        self.auth = auth
        self.firestore = firestore
        
        subscribeToFavoriteXchanges()
    }
    
    deinit {
        unsubscribeFromFavoriteXchanges()
    }
    
    func favor(_ xchange: XChange) {
        guard let userId = auth.currentUserID() else { return }
        guard let docId = xchange.id else { return }
        
        var followers = xchange.followers
        
        if !followers.contains(userId) {
            followers.append(userId)
        }
        
        firestore
            .collection(FirestoreCollection.xChange.path)
            .document(docId)
            .updateData(["followers":followers])
    }
    
    func unfavor(_ xchange: XChange) {
        guard let userId = auth.currentUserID() else { return }
        guard let docId = xchange.id else { return }
        
        let followers = xchange.followers.filter { follower -> Bool in
            follower != userId
        }
        
        firestore
            .collection(FirestoreCollection.xChange.path)
            .document(docId)
            .updateData(["followers":followers])
    }
    
    private func subscribeToFavoriteXchanges() {
        guard let userId = auth.currentUserID() else { return }
        
        favoriteSubscription = firestore
            .collection(FirestoreCollection.xChange.path)
            .whereField("followers", arrayContains: userId)
            .addSnapshotListener {[weak self] snapshot, error in
                
                if let error = error {
                    self?.favoriteXChanges.accept([])
                    print("favourites error: ", error.localizedDescription)
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                let xChanges = documents.compactMap({ (snap) -> XChange? in
                    return try? snap.data(as: XChange.self)
                })
                self?.favoriteXChanges.accept(xChanges)
            }
    }
    
    private func unsubscribeFromFavoriteXchanges() {
        favoriteSubscription?.remove()
    }
    
    func getFavoriteXchanges() -> Driver<[XChange]> {
        favoriteXChanges
            .asDriver()
            .compactMap { $0 }
    }
}
