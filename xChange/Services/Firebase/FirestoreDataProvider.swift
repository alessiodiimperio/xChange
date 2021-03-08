//
//  FirestoreService.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import Firebase
import FirebaseFirestoreSwift
import RxSwift
import RxCocoa

enum FirestoreCollection {
    case xChange
    case users
    var path: String {
        switch self {
        case .users:
            return "users"
        case .xChange:
            return "xchanges"
        }
    }
}

class FirestoreDataProvider: DataProvider {
    
    private let auth:AuthenticationProvider
    private let firestore = Firestore.firestore()
    
    private var userSubscription: ListenerRegistration?
    
    let userXChanges = BehaviorRelay<[XChange]?>(value: nil)
   
    
    init(auth: AuthenticationProvider) {
        self.auth = auth
        
        subscribeToUserXchanges()
    }
    
    deinit {
        unsubscribeFromUserXchanges()
    }
    
    private func subscribeToUserXchanges() {
        
        guard let userId = auth.currentUserID() else { return }
        
        userSubscription = firestore
            .collection(FirestoreCollection.xChange.path)
            .whereField("author", isEqualTo: userId)
            .addSnapshotListener {[weak self] snapshot, error in
                
                if let _ = error {
                    self?.userXChanges.accept([])
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                let xChanges = documents.compactMap({ (snap) -> XChange? in
                    return try? snap.data(as: XChange.self)
                })
                self?.userXChanges.accept(xChanges)
            }
    }
    
    private func unsubscribeFromUserXchanges() {
        userSubscription?.remove()
    }

    func getUsersXchanges() -> Driver<[XChange]> {
        userXChanges
            .asDriver()
            .compactMap { $0 }
    }
    
    func delete(_ xChange: XChange){
        guard let id = xChange.id else { return }
        firestore
            .collection(FirestoreCollection.xChange.path)
            .document(id)
            .delete()
    }
    
    func add(_ xChange: XChange){
        do {
            let _ = try firestore
                .collection(FirestoreCollection.xChange.path)
                .addDocument(from: xChange)
        } catch {
            print(error.localizedDescription)
        }
    }
}
