//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Vance on 4/17/17.
//  Copyright © 2017 Vance. All rights reserved.
//

import UIKit
import Foundation

class CurrencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let global = YahooQuery.sharedInstance
    var queryString = ""
    var unitTable:[[Double]] = [[]]
    // Array setting 2 pickerview
    var unitPick:[String] = []
    // these 2 coressponding arrays virtually correspond to each other
//    let getUnit = ["USD","JPY","GBP","CAD","EUR","CNY"]
//    let USD = 0, JPY = 1, GBP = 2, CAD = 3, EUR = 4, CNY = 5
//    var unitTable = [[Double]](repeating: [Double](repeating: 1.0, count: 6), count: 6)
    
    // these 2 var show what row pickers are at
    var currHome = 0
    var currForeign = 0
    
    // Object in viewcontroller
    @IBOutlet weak var homePicker: UIPickerView!
    @IBOutlet weak var foreignPicker: UIPickerView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!


    
    // Initial set up
    override func viewDidLoad() {
        super.viewDidLoad()
        unitPick = global.getUnitPick()
        unitTable = global.getUnitTable()
        global.readFile()
        global.writeFile()
        global.saveFile()
        
        homePicker.dataSource = self
        homePicker.delegate = self
        foreignPicker.dataSource = self
        foreignPicker.delegate = self
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Swipe Func handleSwipe()
    func handleSwipe(_ sender:UIGestureRecognizer) {
        self.performSegue(withIdentifier: "showFav", sender: self)
    }
    // or touch the button to go to Fav Curr
    @IBAction func gotoFav2(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showFav", sender: self)
    }
    // Enable unwinding
    @IBAction func unwindToCurr(segue:UIStoryboardSegue) {}
    // Pickers set up
    func numberOfComponents(in pickerView: UIPickerView) -> Int {   return 1;   }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {    return unitPick.count   }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitPick[row]
    }
    // Each time changing the pickers, show what row they are at
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == foreignPicker) {  currForeign = row   }
        else if (pickerView == homePicker) {    currHome = row  }
    }
    // Calculate button action
    @IBAction func calculateValue(_ sender: UIButton) {
        if let inputStr = Double(inputTextField.text!) {
            unitTable = global.getUnitTable()
            
            
            resultLabel.text = String(unitTable[currHome][currForeign])
        }
        else {
            resultLabel.text = "Invalid input!"
        }
    }    
}

