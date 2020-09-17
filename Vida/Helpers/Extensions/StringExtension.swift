//
//  StringExtension.swift
//  Vida
//
//  Created by Vida on 13/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

extension String {

    var isOnlyAlphanumeric: Bool {
        let allowedCharacters = CharacterSet.alphanumerics
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    var isOnlyLetters: Bool {
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    var isOnlyNumeric: Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    var isCleanedStringEmpty: Bool {
        let cleanString = trimmingCharacters(in: .whitespacesAndNewlines)
        return cleanString.isEmpty
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isValidCPF: Bool {
        let numbers = flatMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ... end])
    }
    
    var containsNumbers: Bool {
        return utf16.contains { (CharacterSet.decimalDigits as NSCharacterSet).characterIsMember($0) }
    }
    
    var toNumbersOnly: String {
        var number = self
        number = number.replacingOccurrences(of: ".", with: "")
        number = number.replacingOccurrences(of: "-", with: "")
        number = number.replacingOccurrences(of: "/", with: "")
        number = number.replacingOccurrences(of: "(", with: "")
        number = number.replacingOccurrences(of: ")", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        
        return number
    }
    
    var removeCharactersSpecial: String {
        let okayChars = Set("ÀÁÃÂÉÊÍÓÕÔÚÜÇÑàáãâéêíóõôúüçñabcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return self.filter {okayChars.contains($0) }
    }
    
    var removeCharactersSpecialForOpenWebSite: String {
        let okayChars = Set("ÀÁÃÂÉÊÍÓÕÔÚÜÇÑàáãâéêíóõôúüçñabcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890,-.+")
        return self.filter {okayChars.contains($0) }
    }
    
    func replaceDictionary(_ dictionary: [String: String]) -> String {
        var result = String()
        var i = -1
        for (of , with): (String, String)in dictionary{
            i += 1
            if i<1 {
                result = self.replacingOccurrences(of: of, with: with)
            } else {
                result = result.replacingOccurrences(of: of, with: with)
            }
        }
        return result
    }
}
