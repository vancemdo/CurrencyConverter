//
//  FavViewController.swift
//  CurrencyConverter
//
//  Created by Vance on 4/24/17.
//  Copyright © 2017 Vance. All rights reserved.
//

import UIKit

class FavViewController: UITableViewController {
    let global = YahooQuery.sharedInstance
//let getUnit = ["USD","JPY","GBP","CAD","EUR","CNY"]
    @IBOutlet weak var usdCell: UITableViewCell!
    @IBOutlet weak var jpyCell: UITableViewCell!
    @IBOutlet weak var gbpCell: UITableViewCell!
    @IBOutlet weak var cadCell: UITableViewCell!
    @IBOutlet weak var eurCell: UITableViewCell!
    @IBOutlet weak var cnyCell: UITableViewCell!
    
    @IBOutlet var selectionCell: [UITableViewCell]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //favTabVCel.allowsMultipleSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When hiting Done, reset picker selection request query, 
    // write to user's data for later use, then go back to first view.
    @IBAction func gotoCurr(_ sender: UIBarButtonItem) {
        let getUnit = ["USD","JPY","GBP","CAD","EUR","CNY"]
        var selecStr:[String] = []
        var queryAdd = ""
        var unitTableNew:[[Double]]
        var row = 0
        // Reset pickerview
        for i in 0...selectionCell.count - 1 {
            if (selectionCell[i].isSelected) {
                row += 1
                selecStr.append(selectionCell[i].reuseIdentifier!)
                for j in 0...5 {
                    queryAdd += selectionCell[i].reuseIdentifier! + getUnit[j] + ","
                }
            }
        }
        if (selecStr.isEmpty) {
            global.setDefault()
        }
        else {
            queryAdd = String(queryAdd.characters.dropLast())
            global.setQueryString(queryAdd)
            global.setUnitPick(selecStr)
            unitTableNew = [[Double]](repeating:[Double](repeating:1.0, count:6), count:row)
            global.setUnitTable(unitTableNew)
        }
        // Request and reset tableUnit
        global.updateUnitTable()
        
        
        // Write user's data and go back.
        self.performSegue(withIdentifier: "showCurr", sender: self)
    }
}
