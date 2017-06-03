//
//  MainViewController.swift
//  messenger
//
//  Created by Zarif Safiullin on 06/11/15.
//  Copyright © 2015 Zaph. All rights reserved.
//

import UIKit
import Cartography
import XCGLogger

private let log = XCGLogger.defaultInstance()

class MainViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var tabBar: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var btnNewsfeed: UIButton!
    @IBOutlet weak var btnMessages: UIButton!

    
    var slides = [UIViewController]()
    var indicator = UIView(frame: CGRectZero)
    var indicatorCenterXGroup = ConstraintGroup()

    let controllersIndicators = ["NewsfeedViewController", "MessagesViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initIndicator()
        initScrollView()
    }
    
    deinit {
        for (_, slide) in slides.enumerate() {
            slide.willMoveToParentViewController(nil)
            slide.view.removeFromSuperview()
            slide.removeFromParentViewController()
        }
        
        slides = [UIViewController]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        tabBar.backgroundColor = Settings.sharedInstance.backgroundColor
        tabBar.tintColor = Settings.sharedInstance.tintColor
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: ScrollView
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        switch page {
        case 0:
            moveIndicatorTo(button: btnNewsfeed)
        case 1:
            moveIndicatorTo(button: btnMessages)
        default:
            log.debug("Unknow button: \(page)")
        }
    }
    
    // MARK: Indicator
    
    @IBAction func openNewsfeed(sender: UIButton) {
        moveIndicatorTo(button: sender, offset:0)
    }
    
    @IBAction func openMessages(sender: UIButton) {
        moveIndicatorTo(button: sender, offset:1)
    }
    
    private func moveIndicatorTo(button button:UIView) {
        constrain(indicator, button, replace: indicatorCenterXGroup) { (i, b) in
            i.centerX == b.centerX
            i.width == b.width + 22
        }
        
        UIView.animateWithDuration(0.2, animations: indicator.layoutIfNeeded)
    }
    
    private func moveIndicatorTo(button button:UIView, offset:Int) {
        let width = UIScreen.mainScreen().bounds.size.width * CGFloat(offset)
        moveIndicatorTo(button: button)
        
        UIView.animateWithDuration(0.2) {
            self.scrollView.setContentOffset(CGPointMake(width, 0), animated:false)
        }
    }
    
    private func initIndicator() {
        log.debug("initIndicator")
        
        indicator.backgroundColor = UIColor.whiteColor()
        tabBar.addSubview(indicator)
        
        constrain(indicator, btnNewsfeed) { (i, b) in
            i.height == 1
            i.bottom == i.superview!.bottom - 8
        }
        
        indicatorCenterXGroup = constrain(indicator, btnNewsfeed) { (i, b) in
            i.centerX == b.centerX
            i.width == b.width + 11
        }
        
        indicator.layoutIfNeeded()
    }
    
    
    private func initScrollView() {
        scrollView.delegate = self
        
        let storyboard = UIStoryboard(name: "Tabs", bundle: nil)
        
        for storyboardId in controllersIndicators {
            let ctrl = storyboard.instantiateViewControllerWithIdentifier(storyboardId)
            
            addChildViewController(ctrl)
            scrollView.addSubview(ctrl.view)
            ctrl.didMoveToParentViewController(self)
            
            slides.append(ctrl)
        }
        
        constrain(slides[0].view, slides[1].view) { (slide1, slide2) in
            slide2.left == slide1.right
        }
        
        layoutSlideSize(rootView: view, scrollView: scrollView, slide: slides[0].view)
        layoutSlideSize(rootView: view, scrollView: scrollView, slide: slides[1].view)

        
        constrain(scrollView, slides.first!.view) { (scrollView, slide) in
            slide.left == scrollView.left
        }
        
        constrain(scrollView, slides.last!.view) { (scrollView, slide) in
            slide.right == scrollView.right
        }
    }
    
    private func layoutSlideSize(rootView rootView:UIView, scrollView:UIView, slide:UIView) {
        constrain(rootView, scrollView, slide) { (rootView, scrollView, slide) in
            slide.height == scrollView.height
            slide.width == rootView.width
            slide.bottom == scrollView.bottom
            slide.top == scrollView.top
        }
    }
    
    private func tabTitle(text:String) -> NSAttributedString {
        
        let font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        
        return NSAttributedString(string: text, attributes: [
            NSKernAttributeName: 1.24,
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.blackColor()
            ])
    }
}
