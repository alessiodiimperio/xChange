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


    private let auth: AuthenticationProvider
    private let firestore: Firestore
    private let firestoreChats: CollectionReference
    
    private let chats = BehaviorRelay<[Chat]>(value: [])
    private let chat = BehaviorRelay<Chat?>(value: nil)
    
    private(set) var chatsSubscription: ListenerRegistration?
    private(set) var chatSubscription: ListenerRegistration?
    
    init(auth: AuthenticationProvider, firestore: Firestore) {
        self.auth = auth
        self.firestore = firestore
        self.firestoreChats = firestore.collection(FirestoreCollection.chat.path)

        subscribeToChats()
    }
    
    deinit {
        unsubscribeToChats()
    }
    
    private func parseChatIdFor(_ userId: String, and xChangeId: String) -> String {
        if userId < xChangeId {
            return xChangeId.appending(userId)
        } else {
            return userId.appending(xChangeId)
        }
    }
    
    func getChats() -> Driver<[Chat]> {
        chats.asDriver()
    }
    
    func getChat() -> Driver<Chat?> {
        chat.asDriver()
    }
    
    func contactSeller(about xChange: XChange, completion: @escaping (String) -> Void) {
        guard let userId = auth.currentUserID(),
              let xChangeId = xChange.id else { return }
        
        let chatId = parseChatIdFor(userId, and: xChangeId)
        
        firestoreChats
            .document(chatId)
            .getDocument { [weak self] snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let document = snapshot, document.exists {
                    completion(document.documentID)
                } else {
                    self?.createChat(about: xChange, with: chatId) { chatId in
                        completion(chatId)
                    }
                }
            }
    }
    
    func createChat(about xChange: XChange, with chatId: String, completion: @escaping (String) -> Void) {
        guard let xChangeId = xChange.id,
              let userId = auth.currentUserID() else { return }
        
        let chat = Chat(xChangeId: xChangeId,
                        title: xChange.title,
                        image: xChange.image ?? "",
                        itemPrice: xChange.price ?? "",
                        seller: xChange.author,
                        sellerName: xChange.authorName,
                        buyer: userId,
                        chatters: [userId],
                        hasNewMessage: [xChange.author],
                        messages: [ChatMessage](),
                        available: true)
        do {
            try firestoreChats
                .document(chatId)
                .setData(from: chat)
            
            completion(chatId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func send(_ message: ChatMessage, to chat: Chat?) {
        guard let chat = chat,
              let chatId = chat.id,
              let userId = auth.currentUserID()  else { return }
        
        firestoreChats
            .document(chatId)
            .updateData([
                "hasNewMessage": FieldValue.arrayUnion([userId == chat.seller ? chat.buyer : chat.seller]),
                "chatters" : [chat.seller, chat.buyer],
                "messages" :
                            FieldValue.arrayUnion([[
                                "timestamp" : message.timestamp,
                                "senderId" : message.senderId,
                                "senderName" : message.senderName,
                                "message" : message.message
                    ]])
            ])
    }
    
    func remove(_ chat: Chat) {
        guard let userId = auth.currentUserID(),
              let chatId = chat.id else { return }
        
        firestoreChats
            .document(chatId)
            .updateData(["chatters" : FieldValue.arrayRemove([userId])])
    }
    
    func setAsRead(_ chat: Chat) {
        guard let userId = auth.currentUserID(),
              let chatId = chat.id else { return }
        
        firestoreChats
            .document(chatId)
            .updateData(["hasNewMessage": FieldValue.arrayRemove([userId])])
    }
    
    private func subscribeToChats() {
        guard let userId = auth.currentUserID() else { return }
        chatsSubscription = firestoreChats
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
            }
    }
    
    private func unsubscribeToChats () {
        chatsSubscription?.remove()
    }
    
    func subscribeToChat(with chatId: String) {
        chatSubscription = firestoreChats
            .document(chatId)
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let snapshot = snapshot else { return }
                
                let chat = try? snapshot.data(as: Chat.self)
                
                if let chat = chat {
                    self.chat.accept(chat)
                }
            }
    }
    
    func unsubscribeToChat() {
        chatSubscription?.remove()
    }
}
