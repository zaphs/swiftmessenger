//
//  DialogsViewController.swift
//  messenger
//
//  Created by Zarif Safiullin on 23/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import UIKit
import MagicalRecord
import SDWebImage

class DialogsCell: UITableViewCell {
    
    @IBOutlet var onlineStatus: UIImageView!
    @IBOutlet var avatar: RoundImageView!
    @IBOutlet var displayName: UILabel!
    @IBOutlet var previewText: UILabel!
    @IBOutlet var timeLabel: UILabel!
}

class DialogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let reuseIdentifier = "DialogsCell"
    var conversations = [Conversation]()
    var appUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.dataSource = self
        
        getConversations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getConversations() {
        
        HttpClient.sharedInstance.sendRequest(HttpClient.conversationsUrl, parameters: ["test":"1"] ) { rsp in
            
            print(rsp)
            
            switch rsp {
            case .Success(let data):
                
                let items = data["data"]["conversations"]
                
                MagicalRecord.saveWithBlockAndWait { ctx in
                    
                    /** */
                    let userPredicate = NSPredicate(format: "userId = %i", 1)
                    var appUser = User.MR_findFirstWithPredicate(userPredicate, inContext: ctx)
                    if appUser == nil {
                        appUser = User.MR_createEntityInContext(ctx)
                        appUser.userId = 1
                        appUser.online = true
                        appUser.displayName = "Admin"
                        appUser.avatarUrl = "http://ow16/ow_userfiles/plugins/base/avatars/avatar_1_1440342065.jpg"
                    }
                    
                    self.appUser = appUser
                    /** */
                    
                    for(index, data) in items {
                        if let conversationId = data["conversationId"].int,
                            let displayName = data["displayName"].string,
                            let avatarUrl = data["avatarUrl"].string,
                            let subject = data["subject"].string,
                            let lastMessageTimestamp = data["lastMessageTimestamp"].int,
                            let read = data["conversationRead"].bool,
                            let senderId = data["senderId"].int,
                            let recipientId = data["recipientId"].int,
                            let opponentId = data["userId"].int,
                            let previewText = data["previewText"].string,
                            let online = data["onlineStatus"].bool
                        {
                            let predicate = NSPredicate(format: "conversationId = %i", conversationId)
                            var conversation = Conversation.MR_findFirstWithPredicate(predicate, inContext: ctx)
                            
                            if conversation == nil {
                                conversation = Conversation.MR_createEntityInContext(ctx)
                            }
                            
                            conversation.conversationId = conversationId
                            conversation.subject = subject
                            conversation.read = read
//                            conversation.previewText = previewText
                            conversation.timestamp = lastMessageTimestamp
                            
                            let opponentPredicate = NSPredicate(format: "userId = %i", opponentId)
                            var opponent = User.MR_findFirstWithPredicate(opponentPredicate, inContext: ctx)
                            if opponent == nil {
                                opponent = User.MR_createEntityInContext(ctx)
                                opponent.userId = opponentId
                                opponent.online = online
                                opponent.displayName = displayName
                                opponent.avatarUrl = avatarUrl
                            }

                            if senderId == self.appUser.userId {
                                conversation.sender = self.appUser
                                conversation.recipient = opponent
                            }
                            else {
                                conversation.sender = opponent
                                conversation.recipient = self.appUser
                            }
                        }
                    }
                }
                
                self.reloadContent()
                
            case .Error(let error):
                print(error)
                
                self.reloadContent()
            }
            
        }
        
        
    }
    
    func reloadContent() {
        
        if let items = Conversation.MR_findAllSortedBy("lastMessageTimestamp", ascending: false) as? [Conversation]  {
            
            conversations = items
        }
        
        tableView.reloadData()
    }
}

extension DialogsViewController {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return conversations.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DialogsCell
        
        // Configure the cell...
        let conversation = conversations[indexPath.row]
        var opponent: User!
        if conversation.sender.userId == appUser.userId {
            opponent = conversation.recipient
        }
        else {
            opponent = conversation.sender
        }

        cell.displayName.text = opponent.displayName
        cell.avatar.sd_setImageWithURL(NSURL(string: opponent.avatarUrl))
        cell.onlineStatus.hidden = !(opponent.online as Bool)
//        cell.previewText.text = conversation.previewText
        
        let timestamp = NSDate(timeIntervalSince1970: NSTimeInterval(conversation.timestamp))
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        cell.timeLabel.text = dateFormatter.stringFromDate(timestamp)
        
        //TODO show unread status

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let conversation = conversations[indexPath.row]
        var opponent: User!
        if conversation.sender.userId == appUser.userId {
            opponent = conversation.recipient
        }
        else {
            opponent = conversation.sender
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ctrl = ConversationController()
        
        ctrl.senderId = "\(opponent.userId)"
        ctrl.senderDisplayName = "\(opponent.displayName)"

        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Intentionally blank. Required to use UITableViewRowActions
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let markUnread = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Mark as unread") { (action, indexPath) -> Void in

            // remove the deleted item from the model
            let conversation = self.conversations[indexPath.row]
            
            MagicalRecord.saveWithBlockAndWait { ctx in
                conversation.read = true
            }
            
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { (action, indexPath) -> Void in
            
            // remove the deleted item from the model
            self.conversations.removeAtIndex(indexPath.row)
            
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        let arrayofactions: Array = [delete, markUnread]
        
        return arrayofactions
    }
}
