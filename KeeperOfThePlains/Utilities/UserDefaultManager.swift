//
//  userDefaultManager.swift
//  FarmersGuild
//
//  Created by Brian Pagani on 8/24/22.
//

import Foundation

/*
 
 When the player passes a crop
 1. Save that date into userDefautls
 */

struct UserDefaultManager {
    static let shared = UserDefaultManager()
    
    ///Retreives the value from user defaults and conversts to a Date value
    func dateValue() -> Date? {
        print(UserDefaults.standard.string(forKey: Constants.cropKey) as Any)
         let dateString =  UserDefaults.standard.string(forKey: Constants.cropKey) ?? "Unkown Issue"
        let dateFormatter = DateFormatter()
        guard let myDate = dateFormatter.date(from: dateString) else { return nil }
        
        return myDate
       
    }
//    ----> ---> ***
    func setDate() {
        // take thtime stamp
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let myDateAsAString = dateFormatter.string(from: Date())
        
        UserDefaults.standard.set(myDateAsAString, forKey: Constants.cropKey)
        
        //use the top secrete key to save your valu
    }
    
    
}
