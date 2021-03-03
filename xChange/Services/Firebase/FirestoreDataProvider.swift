//
//  FirestoreService.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//

import Firebase
import FirebaseFirestoreSwift
import RxSwift

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

struct FirestoreDataProvider:DataProvider {
    let auth:AuthenticationProvider
    let firestore = Firestore.firestore()
    
    func getLatestXChanges() -> Observable<[XChange]> {
        return Observable.create { (observer) -> Disposable in
            firestore
                .collection(FirestoreCollection.xChange.path)
                .limit(toLast: 50).addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    guard let documents = snapshot?.documents else { return }
                    let xChanges = documents.compactMap({ (snap) -> XChange? in
                        return try? snap.data(as: XChange.self)
                    })
                    observer.onNext(xChanges)
                }
            return Disposables.create()
        }
    }
    
    func getUserXChanges() -> Observable<[XChange]> {
        return Observable.create { (observer) -> Disposable in
            guard let userId = auth.currentUserID() else { return Disposables.create() }
            firestore
                .collection(FirestoreCollection.xChange.path)
                .whereField("author", isEqualTo: userId)
                .addSnapshotListener { snapshot, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        observer.onError(error)
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    let xChanges = documents.compactMap({ (snap) -> XChange? in
                        return try? snap.data(as: XChange.self)
                    })
                    print(xChanges)
                    observer.onNext(xChanges)
                }
            return Disposables.create()
        }
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
