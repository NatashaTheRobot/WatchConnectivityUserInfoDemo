//
//  DataSource.swift
//  WCUserInfoDemo
//
//  Created by Natasha Murashev on 10/12/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//

struct DataSource {
    
    let items: [Item]
    
    enum Item {
        case Food(String)
        case Unknown
    }
    
    init(items: [Item] = [Item]()) {
        self.items = items
    }
    
    func insertItemFromData(data: [String : AnyObject]) -> DataSource {
        
        let updatedItems: [Item]

        if let foodItem = data["foodItem"] as? String {
            updatedItems = [.Food(foodItem)] + items
        } else {
            updatedItems = [.Unknown] + items
        }
        
        return DataSource(items: updatedItems)
    }
}