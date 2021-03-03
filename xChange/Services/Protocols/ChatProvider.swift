//
//  ChatProvider.swift
//  xChange
//
//  Created by Alessio on 2021-02-04.
//

import Foundation
protocol ChatProvider {
    func getConversations()
    func deleteConversation()
    func sendMsg()
}
