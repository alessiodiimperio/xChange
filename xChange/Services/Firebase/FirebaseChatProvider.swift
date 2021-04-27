//
//  FirebaseChatProvider.swift
//  xChange
//
//  Created by Alessio on 2021-03-14.
//
import FirebaseFirestore
import FirebaseAuth
import Foundation
import RxSwift
import RxCocoa

class FirebaseChatProvider: ChatProvider {
    func getConversations() -> Driver<[Chat]> {
        return Driver.empty()
    }
    
    func removeConversation(_ id: String) {
        
    }
    
    func sendMessage(to usaerId: String, about xChange: String) {
        
    }
    
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
    
    func getChats() -> Driver<[Chat]> {
        chats
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
    }
    
    func deleteChat(_ id: String)  {
        firestore.collection(FirestoreCollection.chat.path)
            .document(id)
            .setData(["active" : false])
    }
    
    func send(_ message: String, about xChange: XChange) {
        guard let userId = auth.currentUserID() else { return }
        
        firestore.collection(FirestoreCollection.chat.path)
            .document(parseChatIdFor(user: userId, and: xChange.author))
            .getDocument { snapshot, error in
                if let snapshot = snapshot,
                   snapshot.exists {
                    if let chat = try? snapshot.data(as: Chat.self) {
                        self.add(message, to: chat)
                    }
                } else {
                    self.createChat(with: message, about: xChange)
                }
            }
    }
    
    private func subscribeToChats(){
        guard let userId = auth.currentUserID() else { return }
        chatSubscription = firestore
            .collection(FirestoreCollection.chat.path)
            .whereField("senderId", isEqualTo: userId)
            .whereField("recieverId", isEqualTo: userId)
            .whereField("active", isEqualTo: true)
            .addSnapshotListener {[weak self] (snapshot, error) in
                
                if let error = error {
                    self?.chats.accept([])
                    print("chats error: ", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else { return }
                var chats = [Chat]()
                let result = documents.compactMap({ (snap) -> Chat? in
                    return try? snap.data(as: Chat.self)
                })
                chats.append(contentsOf: result)
                self?.chats.accept(chats)
            }
    }
    
    private func unsubscribeToChats () {
        chatSubscription?.remove()
    }
    
    private func add(_ message: String, to chat: Chat) {
        guard let docId = chat.id,
              let userId = auth.currentUserID(),
              let username = auth.currentUser.value?.username else { return }
        
        let _ = try? firestore.collection(FirestoreCollection.chat.path)
                    .document(docId)
                    .collection(FirestoreCollection.privateMessages.path)
                    .addDocument(from: ChatMessage(senderId: userId,
                                                   senderName: username,
                                                   message: message))
    }
    
    private func createChat(with message: String, about xChange: XChange) {
        guard let userId = auth.currentUserID(),
              let xChangeId = xChange.id else { return }
        let _ = try? firestore
            .collection(FirestoreCollection.chat.path)
            .document(parseChatIdFor(user: userId, and: xChange.author))
            .setData(from: Chat(xChangeId: xChangeId, recieverId: xChange.author, senderId: userId, active: true))
    }
    
    private func parseChatIdFor(user userId: String, and authorId: String) -> String {
        if userId < authorId {
            return authorId.appending(userId)
        } else {
            return userId.appending(authorId)
        }
    }
}
