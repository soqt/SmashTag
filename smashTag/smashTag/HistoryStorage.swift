//
//  HistoryModel.swift
//
//
//  Created by Sam Wang on 9/1/16.
//
//

import Foundation

class HistoryStorage {
    var values: [String] {
        get{return defaults.objectForKey(History.value) as? [String] ?? []}
        set{defaults.setObject(newValue, forKey: History.value) }
    }
    
    private struct History{
        static let value = "SearchHistory"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    func add(text: String) {
        var currentHistory = values
        if let index = currentHistory.indexOf(text) {
            currentHistory.removeAtIndex(index)
        }
        currentHistory.insert(text, atIndex: 0)
        values = currentHistory
    }
    
    func removeAtIndex(index: Int){
        var currentHistory = values
        currentHistory.removeAtIndex(index)
        values = currentHistory
    }
}