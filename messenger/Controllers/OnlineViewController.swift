//
//  OnlineViewController.swift
//  messenger
//
//  Created by Zarif Safiullin on 21/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import UIKit
import MagicalRecord
import SDWebImage


class OnlineViewCell: UITableViewCell {
    
    @IBOutlet var avatar: RoundImageView!
    @IBOutlet var onlineStatus: UIImageView!
    @IBOutlet var displayName: UILabel!
}


class OnlineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let reuseIdentifier = "OnlineViewCell"

    @IBOutlet var tableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.dataSource = self
        
        print(navigationController?.navigationBarHidden)
        
        getUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUsers() {
        HttpClient.sharedInstance.sendRequest(HttpClient.usersOnlineUrl, parameters: ["":""] ) { rsp in
            switch rsp {
            case .Success(let data):
                
                let items = data["data"]["users"]
                
                MagicalRecord.saveWithBlockAndWait { ctx in
                    for(index, data) in items {
                        
                        if let userId = data["userId"].int,
                            let online = data["online"].bool,
                            let displayName = data["displayName"].string,
                            let avatarUrl = data["avatarUrl"].string {
                                
                                let predicate = NSPredicate(format: "userId = %i", userId)
                                var user = User.MR_findFirstWithPredicate(predicate, inContext: ctx)
                                
                                if user == nil {
                                    user = User.MR_createEntityInContext(ctx)
                                }
                                
                                user.userId = userId
                                user.online = online
                                user.displayName = displayName
                                user.avatarUrl = avatarUrl
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

        let predicate = NSPredicate(format: "online = %i", 1)
        if let items = User.MR_findAllSortedBy("userId", ascending: false, withPredicate: predicate) as? [User] {
            
            users = items
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


// MARK: - Table view data source
extension OnlineViewController {
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return users.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! OnlineViewCell
        
        // Configure the cell...
        let user = users[indexPath.row]
        
        cell.displayName.text = user.displayName
        cell.avatar.sd_setImageWithURL(NSURL(string: user.avatarUrl))
        cell.onlineStatus.hidden = !(user.online as Bool)
        
        return cell
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = users[indexPath.row]
        
        let ctrl = ConversationController()
        
        ctrl.senderId = "\(user.userId)"
        ctrl.senderDisplayName = "\(user.displayName)"
 
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
}
