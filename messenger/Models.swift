//
//  Models.swift
//  messenger
//
//  Created by Zarif Safiullin on 21/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import Foundation
import MagicalRecord

//MARK: User

//@objc(User)
class User: NSManagedObject {
    
    @NSManaged var userId: Int
    @NSManaged var online: Bool
    @NSManaged var avatarUrl: String
    @NSManaged var displayName: String
    
    @NSManaged var messagesAsRecipient: Message
    @NSManaged var messagesAsSender: Message
    @NSManaged var conversationsAsRecipient: User
    @NSManaged var conversationsAsSender: User
}

//MARK: Messages

//@objc(Conversation)
class Conversation: NSManagedObject {
    
    @NSManaged var conversationId: Int
    @NSManaged var subject: String
    @NSManaged var read: Bool
    @NSManaged var timestamp: Int

    @NSManaged var sender: User
    @NSManaged var recipient: User
    @NSManaged var messages: NSSet
}


//@objc(Message)
class Message: NSManagedObject {
    
    @NSManaged var messageId: Int
    @NSManaged var timestamp: Int
    @NSManaged var read: Bool
    @NSManaged var isSystem: Bool
    @NSManaged var text: String

    @NSManaged var recipient: User
    @NSManaged var sender: User
    @NSManaged var conversation: Conversation
    @NSManaged var attachments: NSSet
}

//@objc(Attachment)
class Attachment: NSManagedObject {
    
    @NSManaged var attachmentId: Int
    @NSManaged var url: String
    
    @NSManaged var message: Message
    
}

//MARK: Newsfeed
