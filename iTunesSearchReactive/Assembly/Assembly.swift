//
//  Assembly.swift
//  iTunesSearchReactive
//
//  Created by Hajnalka Hegyi on 2016. 11. 15..
//  Copyright © 2016. Hajnalka Hegyi. All rights reserved.
//

import Typhoon
import UIKit

class Assembly: TyphoonAssembly {

    dynamic func resultTableViewController() -> AnyObject {
        return TyphoonDefinition.withClass(iTunesSearchResultTableViewController.self) {
            (definition) in
            
            definition.useInitializer(#selector(UIStoryboard.instantiateViewControllerWithIdentifier(_:))) {
                (initializer) in
                
                initializer.injectParameterWith(resultTableViewIdentifier)
            }
            
            definition.injectProperty("resultViewModel", with:self.extendedResultViewModel())
        }
    }
    
    dynamic func resultViewModel() -> AnyObject {
        return TyphoonDefinition.withClass(iTunesSearchResultViewModel.self) {
            (definition) in
            
            definition.useInitializer(#selector(iTunesSearchResultViewModel.init(resultModel:))) {
                (initializer) in
                
                initializer.injectParameterWith(self.resultModel())
            }
        }
    }
    
    dynamic func extendedResultViewModel() -> AnyObject {
        return TyphoonDefinition.withClass(iTunesExtendedResultViewModel.self) {
            (definition) in
            
            definition.useInitializer(#selector(iTunesExtendedResultViewModel.init(resultModel:))) {
                (initializer) in
                
                initializer.injectParameterWith(self.resultModel())
            }
        }
    }
    
    dynamic func resultModel() -> AnyObject {
        return TyphoonDefinition.withClass(iTunesResult.self) {
            (definition) in
            
            definition.useInitializer(#selector(iTunesResult.init as () -> iTunesResult))
        }
    }
    
}
