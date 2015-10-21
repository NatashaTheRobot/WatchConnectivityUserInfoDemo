//
//  WatchSessionManager.swift
//  WCUserInfoDemo
//
//  Created by Natasha Murashev on 10/12/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//

import WatchConnectivity

protocol DataSourceChangedDelegate {
    func dataSourceDidUpdate(dataSource: DataSource)
}

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession = WCSession.defaultSession()
    
    private var dataSource = DataSource()
    private var dataSourceChangedDelegates = [DataSourceChangedDelegate]()
    
    func startSession() {
        session.delegate = self
        session.activateSession()
    }
    
    func addDataSourceChangedDelegate<T where T: DataSourceChangedDelegate, T: Equatable>(delegate: T) {
        dataSourceChangedDelegates.append(delegate)
    }
    
    func removeDataSourceChangedDelegate<T where T: DataSourceChangedDelegate, T: Equatable>(delegate: T) {
        for (index, dataSourceDelegate) in dataSourceChangedDelegates.enumerate() {
            if let dataSourceDelegate = dataSourceDelegate as? T where dataSourceDelegate == delegate {
                dataSourceChangedDelegates.removeAtIndex(index)
                break
            }
        }
    }
}

// MARK: User Info
// use when your app needs all the data
// FIFO queue
extension WatchSessionManager {
    
    // Receiver
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        // handle receiving user info
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.dataSourceChangedDelegates.forEach {
                if let dataSource = self?.dataSource.insertItemFromData(userInfo) {
                    self?.dataSource = dataSource
                    $0.dataSourceDidUpdate(dataSource)
                }
            }
        }
    }
    
}
