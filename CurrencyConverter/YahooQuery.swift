//
//  YahooQuery.swift
//  CurrencyConverter
//
//  Created by Vance on 5/2/17.
//  Copyright © 2017 Vance. All rights reserved.
//

import Foundation
import UIKit

class YahooQuery {
    let fileName = "Userdata"
    static let sharedInstance:YahooQuery = YahooQuery()
    
    // This store the Yahoo address for query
    var queryString = ""
    func setQueryString(_ add:String) {
        queryString = "select * from yahoo.finance.xchange where pair in (\"" + add + "\")"
    }
    func getQueryString() -> String {
        return queryString
    }
    func setDefault () {
        queryString = "select * from yahoo.finance.xchange where pair in (\"" +  "USDUSD,USDJPY,USDGBP,USDCAD,USDEUR,USDCNY,JPYUSD,JPYJPY,JPYGBP,JPYCAD,JPYEUR,JPYCNY,GBPUSD,GBPJPY,GBPGBP,GBPCAD,GBPEUR,GBPCNY,CADUSD,CADJPY,CADGBP,CADCAD,CADEUR,CADCNY,EURUSD,EURJPY,EURGBP,EURCAD,EUREUR,EURCNY,CNYUSD,CNYJPY,CNYGBP,CNYCAD,CNYEUR,CNYCNY" + "\")"
        unitPick = ["USDollar","Japanese Yen","Brittish Pound", "Canadian Dollar","European Euro","Chinese Yuan"]
    }
    // Query table
    var unitTable:[[Double]] = [[Double]](repeating:[Double](repeating:1.0, count:6), count:6)
    func getUnitTable() -> [[Double]] {
        return unitTable
    }
    func setUnitTable(_ new:[[Double]]) {
        self.unitTable = new
        for row in 0...unitPick.count - 1 {
            for column in 0...5 {
                unitTable[row][column] = new[row][column]
            }
        }
    }
    // Currency unit selection
    var unitPick:[String]
    func getUnitPick() -> [String] {
        return unitPick
    }
    func setUnitPick(_ new:[String]) {
        self.unitPick = new
    }
    
    // Initialize
    init () {
        unitPick = ["USDollar","Japanese Yen","Brittish Pound", "Canadian Dollar","European Euro","Chinese Yuan"]
        // Remember to set the queryString first before requesting the server
        setDefault()
        updateUnitTable()
    }
    
    // Update query
    func updateUnitTable() {
        let myYQL = YQL()
        var i = 0
        myYQL.query(getQueryString()) { jsonDict in
            let queryDict = jsonDict["query"] as! [String: Any]
            let resultDict = queryDict["results"] as! [String: Any]
            let rateDict = resultDict["rate"] as! NSArray
            for row in 0...self.unitPick.count - 1 {
                for column in 0...5 {
                    let rate1 = rateDict[i] as! [String: Any]
                    let rate2 = String(describing: rate1["Rate"]!)
                    let add = Double(rate2)!
                    self.unitTable[row][column] = add
                    print(self.unitTable[row][column])
                    i+=1
                }
            }
        }
    }

    // Save data to file
    func saveFile() {
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        print("FilePath: \(fileURL.path)")
    }
    
    // Write user's data on to Userdata.txt
    func writeFile() {
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        // First, store the user's pickerview selection on currency
        var writeString = ""
        for i in 0...unitPick.count - 1 {
            writeString += unitPick[i] + "\n"
        }
        // Second, store the rate
        writeString += "Rate\n"
        for j in 0...unitPick.count - 1 {
            for h in 0...5 {
                writeString += String(unitTable[j][h]) + "\n"
            }
        }
        writeString += "END OF FILE"
        // Lastly, write to the file Userdata.txt
        do {
            try writeString.write(to: fileURL, atomically: false, encoding: String.Encoding.utf8)
            print ("Write success!")
        } catch let error as NSError {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    
    // Read/collect user's data from Userdata.txt
    func readFile() {
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        // If file does not exist, set default of 6 currencies on each pickerview and query all 36 unit from yahoo
        if (String(describing: fileURL) != "Userdata.txt") {
            queryString = "select * from yahoo.finance.xchange where pair in (\"" + "USDUSD,USDJPY,USDGBP,USDCAD,USDEUR,USDCNY,JPYUSD,JPYJPY,JPYGBP,JPYCAD,JPYEUR,JPYCNY,GBPUSD,GBPJPY,GBPGBP,GBPCAD,GBPEUR,GBPCNY,CADUSD,CADJPY,CADGBP,CADCAD,CADEUR,CADCNY,EURUSD,EURJPY,EURGBP,EURCAD,EUREUR,EURCNY,CNYUSD,CNYJPY,CNYGBP,CNYCAD,CNYEUR,CNYCNY" + "\")"
            unitPick = ["USDollar","Japanese Yen","Brittish Pound", "Canadian Dollar","European Euro","Chinese Yuan"]
        }
        // If file exists, read it!
        else {
            var readString = ""
            var i = 0
            do {
                readString = try String(contentsOf: fileURL)
            } catch let error as NSError {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
            var r = 0
            var c = 0
            var rate = false
            var lineStr = String(describing: readString.components(separatedBy: .newlines))
            while (lineStr != "END OF FILE") {
                if (rate == false) {
                    unitPick[i] = ""
                    i += 1
                }
                if (lineStr == "Rate") {
                    rate = true
                    lineStr = String(describing: readString.components(separatedBy: .newlines))
                }
                if (rate == true) {
                    unitTable[r][c] = Double(lineStr)!
                    c += 1
                    if (c == 6) {
                        c = 0
                        r += 1
                    }
                }
                lineStr = String(describing: readString.components(separatedBy: .newlines))
            }
        }
        
        // First, retrieve user's pickerview selection on currency
        //unitPick
        // Second, retrieve the rate
        //
        
        
        
        
        //        /*** Read from project txt file ***/
        //
        //        // File location
        //        let fileURLProject = Bundle.main.path(forResource: "ProjectTextFile", ofType: "txt")
        //        // Read from the file
        //        var readStringProject = ""
        //        do {
        //            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
        //        } catch let error as NSError {
        //            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        //        }
        //        
        //        print(readStringProject)
    }

}
