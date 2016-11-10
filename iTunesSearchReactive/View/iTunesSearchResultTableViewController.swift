//
//  iTunesSearchResultTableViewController.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 04..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import Foundation
import UIKit

class iTunesSearchResultTableViewController : UITableViewController, UISearchBarDelegate {
    
    var resultViewModel : iTunesSearchResultViewModel
    
    @IBOutlet weak var filterBar: UISearchBar!
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init(_ coder: NSCoder? = nil) {
        self.resultViewModel = iTunesSearchResultViewModel()
        
        if let coder = coder {
            super.init(coder: coder)!
        }
        else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        self.bindViewModel()
    }

    private func bindViewModel() {
        self.rac_signalForSelector(#selector(UISearchBarDelegate.searchBar(_:textDidChange:))) ~> RAC(self.resultViewModel, "filteringTuple")
        
        // delegate needs to be set after rac_signalForSelector is called or we need an empty implementation of the selector otherwise
        self.filterBar.delegate = self
        
        resultViewModel.filterSignal?.subscribeNext{ _ in
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultViewModel.listToShow.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier(searchResultCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.resultViewModel.listToShow[indexPath.row].artistName
        cell.detailTextLabel?.text = self.resultViewModel.listToShow[indexPath.row].mediaType
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        
        return cell
    }
}
