//
//  TestViewController.swift
//  TImeCountingDown
//
//  Created by romance on 16/9/21.
//  Copyright © 2016年 Romance. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var timecountDown: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func countDown(sender: UIButton) {
        TimeCountDownManager.sharedInstance.scheduledCountDownWith("button1", timeInteval: 60, countingDown: { (timeInterval) in
            sender.titleLabel?.text = "剩余\(Int(timeInterval))s"
            sender.enabled = false
            }) { (timeInterval) in
                sender.enabled = true
                sender.titleLabel?.text = "点击开始倒计时"
        }
    }
    @IBAction func countDown2(sender: UIButton) {
        TimeCountDownManager.sharedInstance.scheduledCountDownWith("button2", timeInteval: 60, countingDown: { (timeInterval) in
            sender.titleLabel?.text = "剩余\(Int(timeInterval))s"
            sender.enabled = false
        }) { (timeInterval) in
            sender.enabled = true
            sender.titleLabel?.text = "点击开始倒计时"
        }
    }

    @IBAction func stop(sender: AnyObject) {
        timecountDown.titleLabel?.text = "点击开始倒计时"
        TimeCountDownManager.sharedInstance.cancelAllTask()
    }

    @IBAction func continueTIme(sender: UIButton) {
        TimeCountDownManager.sharedInstance.scheduledCountDownWith("heh", timeInteval: 60, countingDown: { (timeInterval) in
            self.timecountDown.titleLabel?.text = "剩余\(Int(timeInterval))s"
            self.timecountDown.enabled = false
        }) { (timeInterval) in
            self.timecountDown.enabled = true
            self.timecountDown.titleLabel?.text = "点击开始倒计时"
        }
    }
    
    @IBAction func pause(sender: UIButton) {
//        if TimeCountDownManager.sharedInstance.pool.suspended {
//            TimeCountDownManager.sharedInstance.pool.suspended = false
//        } else {
            TimeCountDownManager.sharedInstance.suspendAllTask()
//        }
    }
    
    deinit {
        print("deinit")
    }
}
