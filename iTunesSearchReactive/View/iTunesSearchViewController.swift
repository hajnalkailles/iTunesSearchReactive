//
//  iTunesSearchViewController.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 03..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import Foundation
import ReactiveCocoa
import UIKit

class iTunesSearchViewController : UIViewController {
    
    var searchViewModel: iTunesSearchViewModel
    
    @IBOutlet weak var searchTermTextfield: UITextField!
    @IBOutlet weak var limitTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init(_ coder: NSCoder? = nil) {
        self.searchViewModel = iTunesSearchViewModel(service: NavigationService())
        
        if let coder = coder {
            super.init(coder: coder)!
        }
        else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        searchTermTextfield.rac_textSignal() ~> RAC(self.searchViewModel, "searchTerm")
        limitTextfield.rac_textSignal() ~> RAC(self.searchViewModel, "limit")
        
        searchViewModel.validSearchSignal?.subscribeNext{ valid in
            let isSignalValid = valid as! Bool
            self.searchTermTextfield.backgroundColor = self.backgroundColorForValidState(isSignalValid)
        }
        
        searchViewModel.validLimitSignal?.subscribeNext{ valid in
            let isSignalValid = valid as! Bool
            self.limitTextfield.backgroundColor = self.backgroundColorForValidState(isSignalValid)
        }
        
        searchButton.rac_command = searchViewModel.executeSearch
    }
    
    private func backgroundColorForValidState(valid: Bool) -> UIColor {
        return valid ? UIColor.clearColor() : UIColor.redColor()
    }
}
