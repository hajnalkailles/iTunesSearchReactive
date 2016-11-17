//
//  iTunesAbstractResultViewModel.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 15..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import ReactiveCocoa

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
        listToShow = [];
    }
    
    func cellTitle(index: Int) -> String {
        return "Title"
    }
    
    func cellSubtitle(index: Int) -> String {
        return "Subtitle"
    }
}
