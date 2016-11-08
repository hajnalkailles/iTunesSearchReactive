//
//  iTunesSearchViewModel.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 03..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import Foundation
import ReactiveCocoa

class iTunesSearchViewModel : NSObject {
    
    var searchTerm = ""
    var limit = 0
    var other = ""
    var executeSearch : RACCommand?
    var validSearchSignal : RACSignal?
    var validLimitSignal : RACSignal?
    var validOtherSignal : RACSignal?
    
    private let searchService: iTunesSearchService
    private let navigationService : NavigationService
    
    init(service: NavigationService) {
        self.searchService = iTunesSearchService()
        self.navigationService = service
        
        super.init()
        
        validSearchSignal = RACObserve(self, keyPath: "searchTerm").map{ _ in
            return self.isSearchTermValid()
        }.distinctUntilChanged()
        
        validLimitSignal = RACObserve(self, keyPath: "limit").map{ _ in
            return self.isLimitValid()
        }.distinctUntilChanged()
        
        validOtherSignal = RACObserve(self, keyPath: "other").map{ _ in
            return self.isOtherValid()
            }.distinctUntilChanged()
        
        let combinedSignal = RACSignalEx.combineLatestAs([validSearchSignal!, validLimitSignal!]) {
            (searchTerm:Bool, limit:Bool) in
            return self.isCombinedValid(searchTerm, second: limit)
        }
        
        executeSearch = RACCommand(enabled: combinedSignal) {
            (any:AnyObject!) -> RACSignal in
                return self.searchMediaInfo()
        }
    }
    
    private func isSearchTermValid() -> Bool {
        return searchTerm.characters.count > 3
    }
    
    private func isOtherValid() -> Bool {
        return other.lowercaseString.containsString("accept")
    }
    
    private func isLimitValid() -> Bool {
        return (limit < 40) && (limit > 0)
    }
    
    private func isCombinedValid(first: Bool, second: Bool) -> NSNumber {
        return (first && second) ? 1 : 0
    }

    private func searchMediaInfo() -> RACSignal {
        return searchService.iTunesSearchSignal(searchTerm, limit: limit).doNextAs {
            (results: iTunesResult) -> () in
            let viewModel = iTunesSearchResultViewModel(resultModel: results)
            self.navigationService.pushViewWithViewModel("iTunesSearchResultTableViewController", viewModel: viewModel)
        }
    }
}

