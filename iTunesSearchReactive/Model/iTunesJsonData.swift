//
//  iTunesJsonData.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 07..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import UIKit

class iTunesJsonData: Equatable, Hashable {

    let artistName : String
    let mediaType : String
    
    init() {
        self.artistName = ""
        self.mediaType = ""
    }
    
    init(artistName: String, mediaType: String) {
        self.artistName = artistName
        self.mediaType = mediaType
    }

    var hashValue: Int {
        get {
            return "\(artistName),\(mediaType)".hashValue
        }
    }
}

func ==(lhs: iTunesJsonData, rhs: iTunesJsonData) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
