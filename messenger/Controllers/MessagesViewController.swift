//
//  MessagesViewController.swift
//  messenger
//
//  Created by Zarif Safiullin on 06/11/15.
//  Copyright © 2015 Zaph. All rights reserved.
//

import UIKit
import MagicalRecord

class ConversationCell: UITableViewCell {

    @IBOutlet var avatarImageView: RoundImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    func bindViewModel(viewModel: ConversationViewModel){
        
        let model = viewModel.model
        
        var opponent: User!
        if Manager.sharedInstance.user.userId == model.sender.userId {
            opponent = model.recipient
        } else {
            opponent = model.sender
        }
        
        if let url = NSURL(string: opponent.avatarUrl) {
            avatarImageView.sd_setImageWithURL(url)
        } else {
            avatarImageView.image = UIImage(named: "no_avatar")
        }
        
        nameLabel.text = opponent.displayName
        
        viewModel.message.didChange.addHandler(self, handler: ConversationCell.didChangeMessage)
        viewModel.read.didChange.addHandler(self, handler: ConversationCell.didChangeRead)
        
        viewModel.render()
    }
    
    func didChangeMessage(oldValue: Message, newValue: Message){
        messageLabel.text = newValue.text
        
        let timestamp = NSTimeInterval.init(newValue.timestamp)
        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateFormat = "dd MMM HH:mm"
        timeLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: timestamp))
    }
    
    func didChangeRead(oldValue: Bool, newValue: Bool){
        if !newValue {
            self.backgroundColor = UIColor.whiteColor()
        } else {
            self.backgroundColor = UIColor.whiteColor()
        }
    }
}

class MessagesViewController: UITableViewController {
    
    var conversations = [Conversation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        
        reloadContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reloadContent(){
//        if let items = Conversation.MR_findAllSortedBy("lastMessageTimestamp", ascending: false) as? [Conversation] {
//            conversations = items
//            conversations = items.map({ (conversation) -> ConversationViewModel in
//                return ConversationViewModel(model: conversation)
//            })
        
        MagicalRecord.saveWithBlockAndWait{ctx in
        
            let fakeConversation = Conversation.MR_createEntity()
            fakeConversation.timestamp = 0
            fakeConversation.subject = "Hello!"
            fakeConversation.conversationId = 1
            fakeConversation.read = false
            fakeConversation.sender = Manager.sharedInstance.opponent
            fakeConversation.recipient = Manager.sharedInstance.user
            
            let message = Message.MR_createEntity()
            message.messageId = 1
            message.timestamp = 1
            message.read = false
            message.isSystem = false
            message.text = "Hello! How are you today?"
            message.recipient = Manager.sharedInstance.user
            message.sender = Manager.sharedInstance.opponent
            message.conversation = fakeConversation
            
            fakeConversation.messages = [message]
            
            self.conversations = [fakeConversation]
            
            self.tableView.reloadData()
        }
        
//        }
        

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MessagesViewController {
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConversationCell", forIndexPath: indexPath) as! ConversationCell
        
        let conversation = conversations[indexPath.row]
        cell.bindViewModel(ConversationViewModel(model: conversation))

        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

}
