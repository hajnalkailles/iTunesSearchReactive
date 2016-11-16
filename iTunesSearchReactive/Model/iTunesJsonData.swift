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
    let trackName : String
    let genreName : String
    
    init() {
        self.artistName = ""
        self.trackName = ""
        self.genreName = ""
    }
    
    init(artistName: String, trackName: String, genreName: String) {
        self.artistName = artistName
        self.trackName = trackName
        self.genreName = genreName
    }

    var hashValue: Int {
        get {
            return "\(artistName),\(trackName),\(genreName)".hashValue
        }
    }
}

func ==(lhs: iTunesJsonData, rhs: iTunesJsonData) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
