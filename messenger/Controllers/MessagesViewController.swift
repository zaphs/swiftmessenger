//
//  MessagesViewController.swift
//  messenger
//
//  Created by Zarif Safiullin on 06/11/15.
//  Copyright © 2015 Zaph. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {

    @IBOutlet var avatarImageView: RoundImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
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
        if let items = Conversation.MR_findAllSortedBy("lastMessageTimestamp", ascending: false) as? [Conversation] {
            conversations = items
        }
        
        tableView.reloadData()
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
        
        //TODO get who is opponent
        
        let opponent = conversation.sender
        if let url = NSURL(string: opponent.avatarUrl) {
            cell.avatarImageView.sd_setImageWithURL(url)
        } else {
            cell.avatarImageView.image = UIImage(named: "no_avatar")
        }

        cell.nameLabel.text = conversation.sender.displayName
        
        let predicate = NSPredicate(format: "conversation == %@", conversation)
        let message = Message.MR_findFirstWithPredicate(predicate, sortedBy: "timestamp", ascending: false)
        let timestamp = NSTimeInterval.init(message.timestamp)
        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateFormat = "dd MMM HH:mm"
        cell.timeLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: timestamp))
        cell.messageLabel.text = message.text
    
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
