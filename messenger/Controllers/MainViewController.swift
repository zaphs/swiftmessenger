//
//  MainViewController.swift
//  messenger
//
//  Created by Zarif Safiullin on 06/11/15.
//  Copyright © 2015 Zaph. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var tabBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        tabBarView.backgroundColor = Settings.sharedInstance.backgroundColor
        tabBarView.tintColor = Settings.sharedInstance.tintColor
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
