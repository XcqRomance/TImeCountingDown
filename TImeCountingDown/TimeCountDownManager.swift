//
//  TimeCountDownManager.swift
//  leapParent
//
//  Created by romance on 16/9/19.
//  Copyright © 2016年 Firstleap. All rights reserved.
//

import UIKit

private let shareInstance = TimeCountDownManager()

class TimeCountDownManager: NSObject {
    // 单利
    class var sharedInstance : TimeCountDownManager {
        return shareInstance
    }
    
    var pool: NSOperationQueue
    
    override init() {
        pool = NSOperationQueue()
        super.init()
    }
    
    /**
     *  开始倒计时，如果倒计时管理器里具有相同的key，则直接开始回调。
     *
     *  @param aKey         任务key，用于标示唯一性
     *  @param timeInterval 倒计时总时间，受操作系统后台时间限制，倒计时时间规定不得大于 120 秒.
     *  @param countingDown 倒计时时，会多次回调，提供当前秒数
     *  @param finished     倒计时结束时调用，提供当前秒数，值恒为 0
     */
    func scheduledCountDownWith(key: String, timeInteval: NSTimeInterval, countingDown:TimeCountingDownTaskBlock?,finished:TimeCountingDownTaskBlock?) {

        var task: TimeCountDownTask?
        if coundownTaskExistWith(key, task: &task) {
            task?.countingDownBlcok = countingDown
            task?.finishedBlcok = finished
            if countingDown != nil {
                countingDown!(timeInterval: (task?.leftTimeInterval)!)
            }
        } else {
            task = TimeCountDownTask()
            task?.leftTimeInterval = timeInteval
            task?.countingDownBlcok = countingDown
            task?.finishedBlcok = finished
            task?.name = key
            
            pool.addOperation(task!)
        }
        
    }
    
    /**
     *  查询倒计时任务是否存在
     *
     *  @param akey 任务key
     *  @param task 任务
     *  @return YES - 存在， NO - 不存在
     */
    private func coundownTaskExistWith(key: String,inout task: TimeCountDownTask? ) -> Bool {
        var taskExits = false
        
        for (_, obj)  in pool.operations.enumerate() {
            
            let temptask = obj as! TimeCountDownTask
            if temptask.name == key {
                task = temptask
                taskExits = true
                print("#####\(temptask.leftTimeInterval)")
                break
            }
            
        }
        return taskExits
    }
    
    func cancelAllTask() {
        pool.cancelAllOperations()
    }
    
    func suspendAllTask() {
        pool.suspended = true
    }
}

/// 计时中回调
typealias TimeCountingDownTaskBlock = (timeInterval: NSTimeInterval) -> Void
// 计时结束后回调
typealias TimeFinishedBlock = (timeInterval: NSTimeInterval) -> Void

class TimeCountDownTask: NSOperation {
    var taskIdentifier: UIBackgroundTaskIdentifier = -1
    var leftTimeInterval: NSTimeInterval = 0
    var countingDownBlcok: TimeCountingDownTaskBlock?
    var finishedBlcok: TimeFinishedBlock?
    
    
    
    override func main() {
        
        if self.cancelled {
            return
        }
        taskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
        
        while leftTimeInterval > 0 {
            print("----\(leftTimeInterval)")
            print(self.executing)
            if self.cancelled {
                return
            }
            leftTimeInterval -= 1
            dispatch_async(dispatch_get_main_queue(), {
                if self.countingDownBlcok != nil {
                    self.countingDownBlcok!(timeInterval: self.leftTimeInterval)
                }
            })
            NSThread.sleepForTimeInterval(1)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            if self.cancelled {
                return
            }
            if self.finishedBlcok != nil {
                self.finishedBlcok!(timeInterval: 0)
            }
        }
        
        if taskIdentifier != UIBackgroundTaskInvalid {
            UIApplication.sharedApplication().endBackgroundTask(taskIdentifier)
            taskIdentifier = UIBackgroundTaskInvalid
        }
    }
}
