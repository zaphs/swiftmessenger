//
//  SettingsViewController.swift
//  messenger
//
//  Created by Zarif Safiullin on 23/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import UIKit
import SDWebImage

class InviteFriendButtonCell: UITableViewCell {
    
    
    
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet var imgAvatar: RoundImageView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgOnlineStatus: UIImageView!
    

    @IBOutlet var btnInviteFriends: InviteFriendButtonCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()                
        
        lblUsername.text = Manager.sharedInstance.username
        imgAvatar.sd_setImageWithURL(NSURL(string: Manager.sharedInstance.avatarUrl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
