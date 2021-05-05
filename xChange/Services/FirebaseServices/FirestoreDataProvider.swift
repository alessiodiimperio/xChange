//
//  FirestoreService.swift
//  xChange
//
//  Created by Alessio on 2021-01-27.
//
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxSwift
import RxCocoa

enum FirestoreCollection {
    case xChange
    case users
    case chat
    case directMessages
    
    var path: String {
        switch self {
        case .users:
            return "users"
        case .xChange:
            return "xchanges"
        case .chat:
            return "chats"
        case .directMessages:
            return "directmessages"
        }
    }
}

class FirestoreDataProvider: DataProvider {
    
    private let auth:AuthenticationProvider
    private let firestore: Firestore
    private let storage: Storage
    private let chatService: ChatProvider
    
    private var userSubscription: ListenerRegistration?
    private var xChangeDetailSubscription: ListenerRegistration?
    
    let userXChanges = BehaviorRelay<[XChange]?>(value: nil)
    let xChangeDetail = BehaviorRelay<XChange?>(value: nil)
    
    init(auth: AuthenticationProvider, firestore: Firestore, storage: Storage, chatService: ChatProvider) {
        self.auth = auth
        self.firestore = firestore
        self.storage = storage
        self.chatService = chatService
        
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
    
    func add(_ xChange: XChange, completion: @escaping () -> Void ){
        do {
            let _ = try firestore
                .collection(FirestoreCollection.xChange.path)
                .addDocument(from: xChange)
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func uploadImage(_ image: UIImage, _ completion: @escaping (String?) -> Void) {
        
        let imagesPath = storage.reference(withPath: "images")
        let imageRef = imagesPath.child("\(UUID().uuidString).jpg")
        
        if let uploadData = image.jpegData(compressionQuality: 0.8) {
            imageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(nil)
                    }
                    completion(url?.absoluteString)
                })
            })
        }
    }
    
    func subscribeToChanges(in xChange: XChange) -> Driver<XChange?> {
        guard let id = xChange.id else { return Driver.empty() }
        
        xChangeDetailSubscription = firestore
            .collection(FirestoreCollection.xChange.path)
            .document(id)
            .addSnapshotListener {[weak self] snapshot, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot,
                      let xChange = try? snapshot.data(as: XChange.self) else { return }
                self?.xChangeDetail.accept(xChange)
            }
        return xChangeDetail.asDriver()
    }
    
    func unsubscribeToChanges() {
        xChangeDetailSubscription?.remove()
    }
}
