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
    
    @IBAction func countDown(_ sender: UIButton) {
        TimeCountDownManager.sharedInstance.scheduledCountDownWith("button1", timeInteval: 60, countingDown: { (timeInterval) in
            sender.titleLabel?.text = "剩余\(Int(timeInterval))s"
            sender.isEnabled = false
            }) { (timeInterval) in
                sender.isEnabled = true
                sender.titleLabel?.text = "点击开始倒计时"
        }
    }
    @IBAction func countDown2(_ sender: UIButton) {
        TimeCountDownManager.sharedInstance.scheduledCountDownWith("button2", timeInteval: 60, countingDown: { (timeInterval) in
            sender.titleLabel?.text = "剩余\(Int(timeInterval))s"
            sender.isEnabled = false
        }) { (timeInterval) in
            sender.isEnabled = true
            sender.titleLabel?.text = "点击开始倒计时"
        }
    }

    @IBAction func stop(_ sender: AnyObject) {
        timecountDown.titleLabel?.text = "点击开始倒计时"
        TimeCountDownManager.sharedInstance.cancelAllTask()
    }

    @IBAction func continueTIme(_ sender: UIButton) {
        TimeCountDownManager.sharedInstance.scheduledCountDownWith("heh", timeInteval: 60, countingDown: { (timeInterval) in
            self.timecountDown.titleLabel?.text = "剩余\(Int(timeInterval))s"
            self.timecountDown.isEnabled = false
        }) { (timeInterval) in
            self.timecountDown.isEnabled = true
            self.timecountDown.titleLabel?.text = "点击开始倒计时"
        }
    }
    
    @IBAction func pause(_ sender: UIButton) {
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
