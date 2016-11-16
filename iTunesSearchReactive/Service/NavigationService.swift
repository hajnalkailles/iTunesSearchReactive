//
//  NavigationService.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 04..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import Foundation
import Typhoon
import UIKit

class NavigationService: NSObject {
    
    private let navigationController: UINavigationController
    
    override init() {
        self.navigationController = UINavigationController()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pushViewWithModel(resultModel : iTunesResult) {
        let storyBoard : UIStoryboard = UIStoryboard(name: mainStoryboardName, bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(resultTableViewIdentifier) as! iTunesSearchResultTableViewController
        nextViewController.resultViewModel?.resultModel = resultModel
        self.navigationController.pushViewController(nextViewController, animated: true)
    }
}
