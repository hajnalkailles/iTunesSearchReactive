//
//  iTunesAbstractResultViewModel.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 15..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import ReactiveCocoa
import UIKit

class iTunesAbstractResultViewModel: NSObject {

    var resultModel : iTunesResult
    
    var filteringTuple = RACTuple(objectsFromArray: [UISearchBar()])
    var filterKeyword = ""
    var listToShow : [iTunesJsonData] = []
    
    var filterSignal : RACSignal?
    
    override convenience init() {
        self.init(resultModel:iTunesResult())
    }
    
    init(resultModel : iTunesResult) {
        self.resultModel = resultModel
        super.init()
        
        filterSignal = RACObserve(self, keyPath: "filteringTuple")
            .mapAs { (tuple: RACTuple) -> AnyObject in tuple.first
                let searchBar = tuple.first as! UISearchBar
                self.filterKeyword = searchBar.text!
                return self.filterKeyword
            }.doNext {
                text -> () in
                self.filterResults(text as! String)
        }
    }
    
    func filterResults(searchText : String) {
        var filteredResults = Set<iTunesJsonData>()
        for object in resultModel.jsonDataObject {
            if (object.artistName.lowercaseString .containsString(searchText.lowercaseString)) {
                filteredResults.insert(object)
            }
        }
        
        if ((filteredResults.count < resultModel.jsonDataObject.count) && (!filterKeyword.isEmpty)) {
            listToShow = Array(filteredResults)
        } else {
            listToShow = Array(resultModel.jsonDataObject)
        }
    }
    
    func cellTitle(index: Int) -> String {
        return listToShow[index].trackName
    }
    
    func cellSubtitle(index: Int) -> String {
        return listToShow[index].mediaType
    }
}
