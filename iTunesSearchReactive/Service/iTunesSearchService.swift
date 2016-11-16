//
//  iTunesSearchService.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 03..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import Foundation
import ReactiveCocoa

class iTunesSearchService : NSObject, NSURLSessionDataDelegate {
    
    var searchText : String = ""
    
    func iTunesSearchSignal(searchTerm: String, limit: Int) -> RACSignal {
        self.searchText = searchTerm
        return signalFromRequest(iTunesSearchUrlPrefix + iTunesSearchUrlParameterTerm + searchTerm + "&" + iTunesSearchUrlParameterLimit + String(limit), transform: transformData);
    }
    
    private func transformData(data : NSData) -> iTunesResult {
        var json : [String : AnyObject]!
        var resultObject = iTunesResult()
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String : AnyObject]
        } catch {
            print("Error when creating JSON object.")
        }
        if (json != nil) {
            let resultArray = json[jsonTagResults] as! NSArray
            var resultList : Set<iTunesJsonData> = []
            var appendingItem : iTunesJsonData
        
            for resultDictionary in resultArray as! [NSDictionary] {
                guard
                    let artistName = resultDictionary[jsonTagArtistName] as? String,
                    let mediaTypeName = resultDictionary[jsonTagKind] as? String,
                    let trackName = resultDictionary[jsonTagTrackName] as? String
                else { break }
                appendingItem = iTunesJsonData(artistName: artistName, mediaType: mediaTypeName, trackName: trackName)
                resultList.insert(appendingItem)
            }

            resultObject = iTunesResult(searchString: self.searchText, jsonData: resultList)
        }
            
        return resultObject
    }
    
    private func signalFromRequest(requestURL: String, transform: (NSData) -> iTunesResult) -> RACSignal {
    
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let url = NSURL(string: requestURL)
            let request = NSURLRequest(URL: url!)
    
            let successSignal = self.rac_signalForSelector(#selector(NSURLSessionDataDelegate.URLSession(_:dataTask:didReceiveData:)))
            
            successSignal
                .mapAs { (tuple: RACTuple) -> AnyObject in tuple.third }
                .mapAs(transform)
                .subscribeNext {
                    (next: AnyObject!) -> () in
                    subscriber.sendNext(next)
                    subscriber.sendCompleted()
            }
            
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: self,
                delegateQueue: NSOperationQueue.mainQueue()
            )
            let task = session.dataTaskWithRequest(request)
            task.resume()
            
            return RACDisposable(block: {
            })
        })
    }
}
