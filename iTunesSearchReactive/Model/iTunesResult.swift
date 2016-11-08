//
//  iTunesResult.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 04..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import Foundation

class iTunesResult: NSObject {
    
    let searchString: String
    let jsonDataObject : Set<iTunesJsonData>
    
    override init() {
        self.searchString = ""
        self.jsonDataObject = Set<iTunesJsonData>()
    }
    
    init(searchString: String, jsonData: Set<iTunesJsonData>) {
        self.searchString = searchString
        self.jsonDataObject = jsonData
    }
}
