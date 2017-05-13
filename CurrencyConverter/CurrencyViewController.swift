//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Vance on 4/17/17.
//  Copyright © 2017 Vance. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class CurrencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let global = YahooQuery.sharedInstance
    var homeSymbol:[String] = []
    
    // these 2 var show what row pickers are at
    var currHome = 0
    var currForeign = 0
    
    // Object in viewcontroller
    @IBOutlet weak var homePicker: UIPickerView!
    @IBOutlet weak var foreignPicker: UIPickerView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    func resetPicker() {
        homePicker.reloadAllComponents()
        foreignPicker.reloadAllComponents()
        foreignPicker.selectRow(0, inComponent: 0, animated: true)
        homePicker.selectRow(0, inComponent: 0, animated: true)
        currHome = 0
        currForeign = 0
        resultLabel.text = "Enter value!"
    }
    
    // Initial set up
    override func viewDidLoad() {
        super.viewDidLoad()
        global.readFile()

        homeSymbol = global.getCurrSymbol()
        
        homePicker.tag = 0
        foreignPicker.tag = 1
        
        //homePicker.dataSource = self
        homePicker.delegate = self
        //foreignPicker.dataSource = self
        foreignPicker.delegate = self
        inputTextField.keyboardType = UIKeyboardType.numberPad
        //inputTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround() 
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Swipe Func handleSwipe()
    func handleSwipe(_ sender:UIGestureRecognizer) {
        self.performSegue(withIdentifier: "showFav", sender: self);
    }
    // or touch the button to go to Fav Curr
    @IBAction func gotoFav2(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showFav", sender: self)
    }
    // Enable unwinding
    @IBAction func unwindToCurr(segue:UIStoryboardSegue) {
        resetPicker()
    }
    
    // Pickers set up
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return global.getUnitPick().count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return global.getUnitPick()[row]
    }
    // Each time changing the pickers, show what row they are at
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            currForeign = row
        }
        else {
            currHome = row
        }
    }
    // Calculate button action
    @IBAction func calculateValue(_ sender: UIButton) {
        let homeSymbol = global.getCurrSymbol()
        let unitTable = global.getUnitTable()
        
        if let inputVal = Double(inputTextField.text!) {
            print(unitTable)
            let resultVal = inputVal * unitTable[currHome][currForeign]
            let resultText = homeSymbol[currHome] +
                inputTextField.text! + " is " + homeSymbol[currForeign] + String(resultVal)
            resultLabel.text = resultText
        }
        else {
            resultLabel.text = "Invalid input!"
        }
    }    
}

