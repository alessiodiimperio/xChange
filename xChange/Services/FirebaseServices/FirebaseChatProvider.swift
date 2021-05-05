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
    
    let auth: AuthenticationProvider
    let firestore: Firestore
    
    private let chats = BehaviorRelay<[Chat]>(value: [])
    private let directMessages = BehaviorRelay<[ChatMessage]>(value: [])
    
    private(set) var chatSubscription: ListenerRegistration?
    private(set) var directMessageSubscription: ListenerRegistration?
    
    init(auth: AuthenticationProvider, firestore: Firestore) {
        self.auth = auth
        self.firestore = firestore
        
        subscribeToChats()
    }
    
    deinit {
        unsubscribeToChats()
    }
    
    func getChats() -> Driver<[Chat]> {
        chats.asDriver()
    }
    
    func contactSeller(about xChange: XChange, completion: @escaping (String) -> Void) {
        guard let userId = auth.currentUserID(),
              let xChangeId = xChange.id else { return }
        
        let chatId = parseChatIdFor(userId, and: xChangeId)
        
        firestore.collection(FirestoreCollection.chat.path)
            .document(chatId)
            .getDocument { [weak self] snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let document = snapshot, document.exists {
                    self?.firestore.collection(FirestoreCollection.chat.path)
                        .document(document.documentID)
                        .updateData(["chatters" : [userId, xChange.author]])
                    completion(document.documentID)
                } else {
                    self?.createChat(about: xChange, with: chatId)
                    completion(chatId)
                }
            }
    }
    
    func createChat(about xChange: XChange, with chatId: String) {
        guard let xChangeId = xChange.id,
              let userId = auth.currentUserID() else { return }
        
        let chat = Chat(xChangeId: xChangeId,
                        title: xChange.title,
                        image: xChange.image ?? "",
                        itemPrice: xChange.price ?? "",
                        seller: xChange.author,
                        buyer: userId,
                        chatters: [userId, xChange.author],
                        active: true,
                        hasNewMessage: true)
        do {
            try firestore.collection(FirestoreCollection.chat.path)
                .document(chatId)
                .setData(from: chat)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getChat(with chatId: String, completion: @escaping (Chat?) -> Void) {
        firestore.collection(FirestoreCollection.chat.path)
            .document(chatId)
            .getDocument { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                let result = Result {
                    try? snapshot?.data(as: Chat.self)
                }
                
                switch result {
                case .success(let chat):
                    completion(chat)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
    }

    
    private func subscribeToChats() {
        guard let userId = auth.currentUserID() else { return }
        chatSubscription = firestore
            .collection(FirestoreCollection.chat.path)
            .whereField("chatters", arrayContains: userId)
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
                print("subscribing", chats.count)
            }
    }
    
    private func parseChatIdFor(_ userId: String, and xChangeId: String) -> String {
        if userId < xChangeId {
            return xChangeId.appending(userId)
        } else {
            return userId.appending(xChangeId)
        }
    }
    
    private func unsubscribeToChats () {
        chatSubscription?.remove()
    }
    
    func send(_ message: ChatMessage, to chat: Chat?) {
        guard let chat = chat,
              let chatId = chat.id else { return }
        
        let _ = try? firestore.collection(FirestoreCollection.chat.path)
            .document(chatId)
            .collection(FirestoreCollection.directMessages.path)
            .addDocument(from: message)
    }
    
    func subscribeToDirectMessages(for chat: Chat, completion: @escaping ([ChatMessage]) -> Void) {
        guard let chatId = chat.id else { return completion([]) }
        
        firestore.collection(FirestoreCollection.chat.path)
            .document(chatId)
            .collection(FirestoreCollection.directMessages.path)
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let documents = snapshot?.documents else { return }
                
                var messages = [ChatMessage]()

                let result = documents.compactMap({ (snap) -> ChatMessage? in
                    return try? snap.data(as: ChatMessage.self)
                })
                
                messages.append(contentsOf: result)
                completion(messages)
            }
    }
    
    func unsubscribeToDirectMessages(for chat: Chat) {
        directMessageSubscription?.remove()
    }
    
}
