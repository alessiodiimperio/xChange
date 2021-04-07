//
//  FirebaseChatProvider.swift
//  xChange
//
//  Created by Alessio on 2021-03-14.
//
import Firebase
import Foundation
import RxSwift
import RxCocoa

class FirebaseChatProvider: ChatProvider {
    let auth: AuthenticationProvider
    let firestore: Firestore
    
    private let chats = BehaviorRelay<[Chat]?>(value: nil)
    private(set) var chatSubscription: ListenerRegistration?
    
    init(auth: AuthenticationProvider, firestore: Firestore) {
        self.auth = auth
        self.firestore = firestore
    
        subscribeToChats()
    }
    
    deinit {
        unsubscribeToChats()
    }
    
    func getConversations() -> Driver<[Chat]> {
        chats
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
    }
    
    func deleteConversation()  {
        print("remove user from chat member")
    }
    
    func sendMessage() {
        print("send pretend message about")
    }
    
    private func subscribeToChats(){
        chatSubscription = firestore
            .collection(FirestoreCollection.chat.path)
            .addSnapshotListener {[weak self] snapshot, error in
                
                if let error = error {
                    self?.chats.accept([])
                    print("chats error: ", error.localizedDescription)
                    return
                }
                
                guard let documents = snapshot?.documents else { return
                }
                
                let chats = documents.compactMap({ (snap) -> Chat? in
                    return try? snap.data(as: Chat.self)
                })
                self?.chats.accept(chats)
            }
    }
    
    private func unsubscribeToChats () {
        chatSubscription?.remove()
    }
}
