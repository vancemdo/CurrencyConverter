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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.myTableView.allowsMultipleSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func gotoCurr(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showCurr", sender: self)
    }
    
}
