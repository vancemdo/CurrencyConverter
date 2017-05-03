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
    // Array setting home pickerview
    var unitPick:[String] = []
    // Array setting foreign pickerview
    let foreignUnit = ["USDollarFOREIGN","Japanese Yen","Brittish Pound", "Canadian Dollar","European Euro","Chinese Yuan"]
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
        global.readFile()
        unitPick = global.getUnitPick()
        unitTable = global.getUnitTable()
        
        //global.writeFile()
        //global.saveFile()
        
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
    @IBAction func unwindToCurr(segue:UIStoryboardSegue) {
        //self.viewDidLoad()
    }
    
    // Pickers set up
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        unitPick = global.getUnitPick()
        if (pickerView == homePicker) {
            print("unitPick.count===")
            print(unitPick.count)
            return unitPick.count - 1
        }
        return foreignUnit.count - 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        unitPick = global.getUnitPick()
        if (pickerView == homePicker) {
            return unitPick[row]
        }
        return foreignUnit[row]
    }
    // Each time changing the pickers, show what row they are at
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //unitPick = global.getUnitPick()
        if (pickerView == foreignPicker) {
            currForeign = row
        }
        else if (pickerView == homePicker) {
            currHome = row
        }
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

