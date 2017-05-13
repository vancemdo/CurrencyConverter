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
    
    @IBOutlet var selectionCell: [UITableViewCell]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //favTabVCel.allowsMultipleSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // When hiting Done, reset picker selection request query, 
    // then go back to first view.
    @IBAction func gotoCurr(_ sender: UIBarButtonItem) {
        //let getUnit = ["USD","JPY","GBP","CAD","EUR","CNY"]
        let nameUnit = ["USDollar","Japanese Yen","British Pound", "Canadian Dollar","European Euro","Chinese Yuan"]
        let symbol = ["$","J¥","£","C$","€","C¥"]
        var queryAdd = ""
        
        var newUnitPick:[String] = []
        var newSymbol:[String] = []
        var newUnit:[String] = []

        
        // Reset query string
        for i in 0...selectionCell.count - 1 {
            if (selectionCell[i].isSelected) {
                let identity:String = selectionCell[i].reuseIdentifier!
                newSymbol.append(symbol[i])
                newUnitPick.append(nameUnit[i])
                newUnit.append(identity)
            }
        }
        
        if (newUnitPick.isEmpty) {
            global.setDefault()
        }
        else {
            for j in 0...newUnit.count - 1 {
                for h in 0...newUnit.count - 1 {
                    queryAdd += newUnit[j] + newUnit[h] + ","
                }
            }
            queryAdd = String(queryAdd.characters.dropLast())
            global.setQueryString(queryAdd)
            global.setUnitPick(newUnitPick)
            global.setCurrSymbol(newSymbol)
        }
        // Request and reset tableUnit
        global.updateUnitTable()
        // Go back
        self.performSegue(withIdentifier: "showCurr", sender: self)
    }
}
