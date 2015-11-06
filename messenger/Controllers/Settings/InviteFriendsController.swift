//
//  InviteFriendsController.swift
//  messenger
//
//  Created by Zarif Safiullin on 06/09/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import UIKit
import SDWebImage

class Friend: NSObject {
    let name: String
    let avatarUrl: String
    
    init(name: String, avatarUrl: String){
        self.name = name
        self.avatarUrl = avatarUrl
    }
}

class InviteFriendsCell: UITableViewCell {
    @IBOutlet var avatar: RoundImageView!
    @IBOutlet var name: UILabel!    
}


class InviteFriendsController: UITableViewController {
    
    let kReuseIdentifier = "InviteFriendsCell"
    
    var friends: [Friend]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: UIBarButtonItemStyle.Done, target: self, action: Selector("invitePressed:"))
//        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("invitePressed:"))
        navigationItem.leftBarButtonItem?.title = " "
        
        friends = [Friend]()
        
        HttpClient.sharedInstance.sendRequest("", parameters: ["userId": 1]) { response in
        
            switch response{
            case .Success(let json):
                for (index, item) in json {
                    if let name = json["name"].string,
                    let avatarUrl = json["avatarUrl"].string {
                        let friend = Friend(name: name, avatarUrl: avatarUrl)
                        self.friends.append(friend)
                    }
                }
            case .Error(let error):
                print(error)
            }

        }
        
        let fr = Friend(name: "Viki", avatarUrl: "")
        friends.append(fr)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return friends.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReuseIdentifier, forIndexPath: indexPath) as! InviteFriendsCell

        let friend = friends[indexPath.row]
        
        cell.avatar.sd_setImageWithURL(NSURL(string: friend.avatarUrl))
        cell.name.text = friend.name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! InviteFriendsCell
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! InviteFriendsCell
        
        cell.accessoryType = UITableViewCellAccessoryType.None
    }

    
    func invitePressed(sender: UIBarButtonItem) {
        
        NSLog("send invites")
        
    }
    
    
}
