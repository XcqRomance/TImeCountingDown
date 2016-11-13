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
    
    var pool: OperationQueue
    
    override init() {
        pool = OperationQueue()
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
    func scheduledCountDownWith(_ key: String, timeInteval: TimeInterval, countingDown:TimeCountingDownTaskBlock?,finished:TimeCountingDownTaskBlock?) {

        var task: TimeCountDownTask?
        if coundownTaskExistWith(key, task: &task) {
            task?.countingDownBlcok = countingDown
            task?.finishedBlcok = finished
            if countingDown != nil {
                countingDown!((task?.leftTimeInterval)!)
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
    fileprivate func coundownTaskExistWith(_ key: String,task: inout TimeCountDownTask? ) -> Bool {
        var taskExits = false
        
        for (_, obj)  in pool.operations.enumerated() {
            
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
        pool.isSuspended = true
    }
}

/// 计时中回调
typealias TimeCountingDownTaskBlock = (_ timeInterval: TimeInterval) -> Void
// 计时结束后回调
typealias TimeFinishedBlock = (_ timeInterval: TimeInterval) -> Void

class TimeCountDownTask: Operation {
    var taskIdentifier: UIBackgroundTaskIdentifier = -1
    var leftTimeInterval: TimeInterval = 0
    var countingDownBlcok: TimeCountingDownTaskBlock?
    var finishedBlcok: TimeFinishedBlock?
    
    
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        taskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        while leftTimeInterval > 0 {
            print("----\(leftTimeInterval)")
            print(self.isExecuting)
            if self.isCancelled {
                return
            }
            leftTimeInterval -= 1
            DispatchQueue.main.async(execute: {
                if self.countingDownBlcok != nil {
                    self.countingDownBlcok!(self.leftTimeInterval)
                }
            })
            Thread.sleep(forTimeInterval: 1)
        }
        
        DispatchQueue.main.async {
            if self.isCancelled {
                return
            }
            if self.finishedBlcok != nil {
                self.finishedBlcok!(0)
            }
        }
        
        if taskIdentifier != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(taskIdentifier)
            taskIdentifier = UIBackgroundTaskInvalid
        }
    }
}
