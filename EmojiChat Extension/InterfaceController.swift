//
//  InterfaceController.swift
//  EmojiChat Extension
//
//  Created by Natasha Murashev on 10/8/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, DataSourceChangedDelegate {
    
    @IBOutlet var foodTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(self)
        loadTableData(DataSource())
    }
    
    override func didDeactivate() {
        
        // remove InterfaceController as a dataSourceChangedDelegate
        // to prevent memory leaks
        WatchSessionManager.sharedManager.removeDataSourceChangedDelegate(self)
        super.didDeactivate()
    }
    
    // MARK: DataSourceUpdatedDelegate
    // update the table once the data is changed!
    func dataSourceDidUpdate(dataSource: DataSource) {
        loadTableData(dataSource)
    }

}

private extension InterfaceController {
    
    private func loadTableData(dataSource: DataSource) {
        
        foodTable.setNumberOfRows(dataSource.items.count, withRowType: "FoodTableRowController")
        
        for (index, item) in dataSource.items.enumerate() {
            if let row = foodTable.rowControllerAtIndex(index) as? FoodTableRowController {
                switch item {
                case .Food(let foodItem):
                    row.foodLabel.setText(foodItem)
                case .Unknown:
                    row.foodLabel.setText("¯\\_(ツ)_/¯")
                }
                
            }
        }
        
    }

}
