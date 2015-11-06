//
//  ChatViewController.swift
//  messenger
//
//  Created by Zarif Safiullin on 22/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import UIKit

class ChatViewModel {
    
}

class ChatViewController: UIViewController {

    
    
    @IBOutlet var myNavigationItem: UINavigationItem!
    
    @IBOutlet var tabs: UISegmentedControl!
    @IBOutlet var search: UIButton!
    @IBOutlet var tabBar: UIView!
    var counter: UILabel!
    var firstAppear = true
    
    @IBOutlet var scrollView: UIScrollView!
    
    enum Controllers: String {
        case DialogsViewController = "DialogsViewController"
        case OnlineViewController = "OnlineViewController"
    }
    
//    let controllersIndicators = [Controllers.DialogsViewController.rawValue, Controllers.OnlineViewController.rawValue]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        counter = UILabel(frame: CGRect(x: 78, y: 5, width: 15, height: 15))
        counter.text = "0"
        counter.backgroundColor = UIColor.redColor()
        counter.textColor = UIColor.whiteColor()
        counter.font = UIFont.systemFontOfSize(13)
        counter.layer.masksToBounds = true
        counter.layer.cornerRadius = 8
        counter.layer.zPosition = 9
        counter.textAlignment = NSTextAlignment.Center
//        counter.sizeToFit()
        
//        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        counter.drawTextInRect( UIEdgeInsetsInsetRect(counter.frame, insets) )

//        counter.hidden = true

        tabs.insertSubview(counter, atIndex: 3)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("newMessageReceived:"), name: WXNotifications.NewMessageReceived.rawValue, object: nil)
        
        navigationItem.titleView?.insertSubview(counter, atIndex: 3)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if firstAppear {
            _openController(Controllers.DialogsViewController.rawValue)
            firstAppear = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func _openController(storyboardId: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ctrl = storyboard.instantiateViewControllerWithIdentifier(storyboardId) 
        
        addChildViewController(ctrl)
        scrollView.addSubview(ctrl.view)
        ctrl.didMoveToParentViewController(self)
    }    
    
    @IBAction func openSegment(sender: UISegmentedControl) {
        
        if (sender.selectedSegmentIndex == 0){
            _openController(Controllers.DialogsViewController.rawValue)
        }
        
        if (sender.selectedSegmentIndex == 1){
            _openController(Controllers.OnlineViewController.rawValue)
        }
    }
    
    func newMessageReceived(notification: NSNotification){
        
        let data = notification.userInfo as! Dictionary<String, Int>
        
        if let count = data["newMessageCount"]  {
            if count > 0 {
                counter.hidden = false
            }
            else {
                counter.hidden = true
            }
            
            counter.text = "\(count)"
        }
    }
    
}
