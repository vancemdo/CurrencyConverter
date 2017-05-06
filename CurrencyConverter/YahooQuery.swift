//
//  YahooQuery.swift
//  CurrencyConverter
//
//  Created by Vance on 5/2/17.
//  Copyright © 2017 Vance. All rights reserved.
//

import UIKit

class YahooQuery {
    static let sharedInstance:YahooQuery = YahooQuery()
    let fileName = "Userdata"
    
    // Currency symbol
    var currSymbol:[String]
    func getCurrSymbol() -> [String] {
        return self.currSymbol
    }
    func setCurrSymbol(_ new:[String]) {
        self.currSymbol = new
    }
    
    // This store the Yahoo address for query
    var queryString:String
    func setQueryString(_ add:String) {
        self.queryString = "select * from yahoo.finance.xchange where pair in (\"" + add + "\")"
    }
    // Set default if read file does not exist and user does not choose anything from favorite
    func setDefault () {
        self.setQueryString("USDUSD,USDJPY,USDGBP,USDCAD,USDEUR,USDCNY,JPYUSD,JPYJPY,JPYGBP,JPYCAD,JPYEUR,JPYCNY,GBPUSD,GBPJPY,GBPGBP,GBPCAD,GBPEUR,GBPCNY,CADUSD,CADJPY,CADGBP,CADCAD,CADEUR,CADCNY,EURUSD,EURJPY,EURGBP,EURCAD,EUREUR,EURCNY,CNYUSD,CNYJPY,CNYGBP,CNYCAD,CNYEUR,CNYCNY")
        self.setUnitPick(["USDollar","Japanese Yen","British Pound", "Canadian Dollar","European Euro","Chinese Yuan"])
        self.setCurrSymbol(["$","J¥","£","C$","€","C¥"])
    }
    // Query table
    var unitTable:[[Double]]
    func getUnitTable() -> [[Double]] {
        return self.unitTable
    }
    func setUnitTable(_ new:[[Double]]) {
        self.unitTable = new
    }
    // Currency unit selection
    var unitPick:[String]
    func getUnitPick() -> [String] {
        return self.unitPick
    }
    func setUnitPick(_ new:[String]) {
        self.unitPick = new
    }
    
    // Initialize
    init () {
        self.unitPick = []
        self.queryString = ""
        self.unitTable = []
        self.currSymbol = []
        // Remember to set the queryString first before requesting the server
        self.setDefault()
        self.updateUnitTable()
    }
    
    // Update query
    func updateUnitTable() {
        self.unitTable = []
        let myYQL = YQL()
        var i = 0
        myYQL.query(self.queryString) { jsonDict in
            let queryDict = jsonDict["query"] as! [String: Any]
            let resultDict = queryDict["results"] as! [String: Any]
            let rateDict = resultDict["rate"] as! NSArray
            for _ in 0...self.unitPick.count - 1 {
                var element:[Double] = []
                for _ in 0...5 {
                    let rate1 = rateDict[i] as! [String: Any]
                    let rate2 = String(describing: rate1["Rate"]!)
                    let add = Double(rate2)!
                    element.append(add)
                    i += 1
                }
                self.unitTable.append(element)
            }
            self.writeFile()
        }
    }
    
    // Write user's data on to Userdata.txt
    func writeFile() {
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        // First, store the user's pickerview selection on currency
        var writeString = ""
        for i in 0...self.unitPick.count - 1 {
            writeString += self.unitPick[i] + "\n"
        }
        // Second, store the rate
        writeString += "Rate\n"
        for j in 0...self.unitPick.count - 1 {
            for h in 0...5 {
                writeString += String(self.unitTable[j][h]) + "\n"
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
        
        var readString = ""
        do {
            readString = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        if (readString == "") {
            readString = firstTimeRun
        }
        var newUnitPick: [String] = []
        var newCurrSymbol: [String] = []
        var newUnitTable: [[Double]] = []
        var rate = false
        var lineStr = readString.components(separatedBy: .newlines)

        var i = 0
        while (i < lineStr.count - 1) {
            if (lineStr[i] != "Rate" && rate == false) {
                newUnitPick.append(lineStr[i])
                switch lineStr[i] {
                    case "USDollar": newCurrSymbol.append("$")
                    case "Japanese Yen": newCurrSymbol.append("J¥")
                    case "British Pound": newCurrSymbol.append("£")
                    case "Canadian Dollar": newCurrSymbol.append("C$")
                    case "European Euro": newCurrSymbol.append("€")
                    case "Chinese Yuan": newCurrSymbol.append("C¥")
                    default: break
                }
                i += 1
            }
            else if (lineStr[i] == "Rate" && rate == false) {
                rate = true
                i += 1
            }
            else if (rate == true && lineStr[i] != "END OF FILE") {
                var element:[Double] = []
                for _ in 0...5 {
                    element.append(Double(lineStr[i])!)
                    i += 1
                }
                newUnitTable.append(element)
            }
        }
        self.setUnitPick(newUnitPick)
        self.setCurrSymbol(newCurrSymbol)
        self.setUnitTable(newUnitTable)
    }
    private let firstTimeRun = "USDollar\nJapanese Yen\nBritish Pound\nCanadian Dollar\nEuropean Euro\nChinese Yuan\nRate\n1.0\n112.681\n0.777\n1.3728\n0.9181\n6.8967\n0.0089\n1.0\n0.0069\n0.0122\n0.0081\n0.0611\n1.2869\n145.008\n1.0\n1.7667\n1.1818\n8.8751\n0.7282\n82.078\n0.5654\n1.0\n0.6686\n5.0225\n1.0889\n122.704\n0.8461\n1.4949\n1.0\n7.5101\n0.1449\n16.316\n0.1126\n0.1986\n0.1331\n1.0\nEND OF FILE"
}
