//
//  ConversationController.swift
//  messenger
//
//  Created by Zarif Safiullin on 23/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ConversationController: JSQMessagesViewController {
    
    override class func nib() -> UINib {
        return UINib(nibName: "ConversationController", bundle: NSBundle.mainBundle() )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("ConversationController.viewDidDisappear")
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
