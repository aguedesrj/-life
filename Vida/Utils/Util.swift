//
//  Util.swift
//  Vida
//
//  Created by Vida on 08/04/2019.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire

final class Util {
    
    class func dialToPhoneNumber(_ phoneNumber: String) {
        let set = NSCharacterSet(charactersIn: "0123456789").inverted
        let cleanedString = phoneNumber.components(separatedBy: set).reduce("", { $0 + $1 })
        let phone = "tel://" + cleanedString
        if let url = URL(string: phone) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func convertFromStringToDateService(dateString: String, format: String) throws -> String {
        var newDateString: String = dateString
        if dateString.count > 15 {
            newDateString = dateString[0..<15]
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let date: Date? = dateFormatter.date(from: newDateString)
        
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date!)
    }
    
    class func convertFromStringToDate(dateString: String) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        return date!
    }
    
    class func convertFromStringToDate(dateString: String, format: String) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = format
        let date: Date? = dateFormatter.date(from: dateString)
        return date!
    }
    
    class func convertFromDateToString(date: Date?, format: String) -> String {
        if (date == nil) {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "pt_BR")
        let returnDate: String = dateFormatter.string(from: date!)
        return returnDate
    }
    
    class func isNotConnectedToNetwork() -> Bool {
        if NetworkReachabilityManager()!.isReachable {
            return false
        }
        return true
    }
    
    class func replaceCaracterSpecial(value: String) -> String {
        let valueUppercased = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let dictionary = ["À": "A",
                          "Á": "A",
                          "Ã": "A",
                          "Â": "A",
                          "É": "E",
                          "Ê": "E",
                          "Í": "I",
                          "Ó": "O",
                          "Õ": "O",
                          "Ô": "O",
                          "Ú": "U",
                          "Ü": "U",
                          "Ç": "C",
                          "Ñ": "N"]
        return valueUppercased.replaceDictionary(dictionary)
    }
    
    class func getMonthAbbreviated(month: Int) -> String {
        switch month {
        case 1:
            return "JAN"
        case 2:
            return "FEV"
        case 3:
            return "MAR"
        case 4:
            return "ABR"
        case 5:
            return "MAI"
        case 6:
            return "JUN"
        case 7:
            return "JUL"
        case 8:
            return "AGO"
        case 9:
            return "SET"
        case 10:
            return "OUT"
        case 11:
            return "NOV"
        default:
            return "DEZ"
        }
    }
    
    class func phoneFormatter(with textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringArray = Array(string)
        for i in 0..<(stringArray.count) {
            if !String(stringArray[i]).containsNumbers {
                return false
            }
        }
        
        var currentString: String? = textField.text
        
        if string == "" {
            currentString = currentString?.toNumbersOnly
            if (currentString?.count ?? 0) == 11 {
                currentString = String(format: "(%@) %@-%@", currentString![0..<1], currentString![2..<5], currentString![6..<10])
                textField.text = currentString
            }
            return true
        }
        
        if (currentString?.count ?? 0) >= 15 {
            return false
        }
        
        if currentString?.count == 14 {
            currentString = currentString?.appending(string)
            let numbers = currentString?.toNumbersOnly
            if (numbers?.count ?? 0) == 11 {
                currentString = String(format: "(%@) %@-%@", numbers![0..<1], numbers![2..<6], numbers![7..<10])
            }
            else {
                currentString = currentString?.appending(string)
            }
            textField.text = currentString
        }
        else {
            currentString = currentString?.appending(string)
            let numbers = currentString!.toNumbersOnly
            var phoneFormatter: String = ""
            let stringArray = Array(numbers)
            for i in 0..<(stringArray.count) {
                if i == 0 {
                    phoneFormatter = phoneFormatter.appending("(\(stringArray[i])")
                }
                else if i == 1 {
                    phoneFormatter = phoneFormatter.appending("\(stringArray[i])) ")
                }
                else if i == 5 {
                    phoneFormatter = phoneFormatter.appending("\(stringArray[i])-")
                }
                else {
                    phoneFormatter = phoneFormatter.appending("\(stringArray[i])")
                }
            }
            textField.text = phoneFormatter
        }
        return false
    }
}
