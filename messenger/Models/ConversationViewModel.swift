//
//  ConversationViewModel.swift
//  messenger
//
//  Created by Zarif Safiullin on 07/11/15.
//  Copyright © 2015 Zaph. All rights reserved.
//

import Foundation

class ConversationViewModel {

    let model:Conversation

    var read: Observable<Bool>
    var timestamp: Observable<Int>
    var message: Observable<Message>
    var messagesCount: Observable<Int>
    
    init(model: Conversation){
        self.model = model

        self.read = Observable<Bool>(model.read)
        
        self.timestamp = Observable<Int>(model.timestamp)
        
        let predicate = NSPredicate(format: "conversation == %@", self.model)
        self.message = Observable<Message>(Message.MR_findFirstWithPredicate(predicate, sortedBy: "timestamp", ascending: false))
        
        self.messagesCount = Observable<Int>(model.messages.count)
        self.messagesCount.didChange.addHandler(self, handler: ConversationViewModel.didChangeMessagesCount)
    }
    
    func render(){
        read.didChange.raise((read.get(), read.get()))
        message.didChange.raise((message.get(), message.get()))
    }
    
    func didChangeMessagesCount(oldValue: Int, newValue: Int){
        let predicate = NSPredicate(format: "conversation == %@", self.model)
        let message = Message.MR_findFirstWithPredicate(predicate, sortedBy: "timestamp", ascending: false)
        self.message.set(message)
    }
}