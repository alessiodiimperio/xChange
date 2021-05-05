//
//  FirebaseFeedProvider.swift
//  xChange
//
//  Created by Alessio on 2021-03-07.
//
import Foundation
import FirebaseFirestore
import RxSwift
import RxCocoa

class FirebaseFeedProvider: FeedProvider {
    private let auth:AuthenticationProvider
    private let firestore: Firestore
    
    private var latestSubscription: ListenerRegistration?
    
    let feed = BehaviorRelay<[XChange]?>(value: nil)

    init(auth: AuthenticationProvider, firestore: Firestore) {
        self.auth = auth
        self.firestore = firestore
        
        subscribeToLatestXchanges()
    }
    
    deinit {
        unsubscribeFromLatestXchanges()
    }
    
    private func subscribeToLatestXchanges() {
        latestSubscription = firestore
            .collection(FirestoreCollection.xChange.path)
            .addSnapshotListener {[weak self] snapshot, error in
                if let error = error {
                    self?.feed.accept([])
                    print("feed error: ", error.localizedDescription)
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                let xChanges = documents.compactMap({ (snap) -> XChange? in
                    return try? snap.data(as: XChange.self)
                })
                print(xChanges)
                self?.feed.accept(xChanges)
            }
    }
    
    private func unsubscribeFromLatestXchanges() {
        latestSubscription?.remove()
    }
    
    func getFeed() -> Driver<[XChange]> {
        feed
            .asDriver()
            .compactMap { $0 }
    }
}
