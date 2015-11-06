//
//  Ping.swift
//  messenger
//
//  Created by Zarif Safiullin on 21/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import Foundation
import SwiftyJSON

class PingPrepareBlock {}
class PingCompleteBlock {}

class PingCommand  : NSObject {
    
    var name: String
    var defaultParams: [String : String]
    
    var completeBlock: (params: JSON) -> Bool
    var prepareBlock: (params: [String: String]) -> Bool
    
    init(name: String, defaultParams: [String : String], prepareBlock: (params: [String: String]) -> Bool, completeBlock: (params: JSON) -> Bool) {

        self.name = name;
        self.defaultParams = defaultParams;
        self.completeBlock = completeBlock;
        self.prepareBlock = prepareBlock;
    }
}


class Ping : NSObject {
    
    static let sharedInstance: Ping = Ping()

    var timer: NSTimer
    var commandList: [String: PingCommand]
    
    func start() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            
            self.spinner()

        })
    }

    func stop() {
        if self.timer.valid {
            self.timer.invalidate()
        }
    }
    
    override init() {
        commandList = [String: PingCommand]()
        timer = NSTimer()
    }

    func spinner() {
        print("Ping.spinner")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("spin"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
        NSRunLoop.currentRunLoop().run()
    }

    func addCommand(command: PingCommand) {
        print("Ping.addCommand: \(command.name)")
        commandList[command.name] = command
    }

    func prepareCommand(command: PingCommand) -> [String : AnyObject]? {
        let params: [String: String] = command.defaultParams ?? [String: String]()

        let perform = command.prepareBlock(params: params)
        
        if !perform {
            return nil
        }
        
        return ["name": command.name, "params": params]
    }
    
    func spin() {
        var commands = [[String : AnyObject]]()
        for (_, command) in commandList {
            if let commandQuery: [String : AnyObject] = prepareCommand(command) {
                commands.append(commandQuery)
            }
        }

        if commands.count == 0 {
            return
        }

        let jsonData = ["commands": commands]
        
        HttpClient.sharedInstance.sendRequest(HttpClient.pingUrl, parameters: jsonData) { rsp  in
        
            switch rsp {
            case .Success(let data):
                
                self.acceptResponse(data)
                
            case .Error(let error):
                print("Error Ping:")
                print(error)
            }
        }
    }

    func acceptResponse(response: JSON) {
        
        if let commands = response["data"]["commands"].array {
            for commandData in commands {

                if let name = commandData["name"].string {
                    if let command = commandList[name] {
                        let data = commandData["data"] as JSON
                        command.completeBlock(params: data)
                    }
                }
            }
        }
    }
}