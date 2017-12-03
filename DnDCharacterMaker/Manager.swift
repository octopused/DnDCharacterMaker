//
//  Manager.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 14.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import Foundation
import CoreData

struct Manager {
    
    public static var shared = Manager()
    
    public var currentHero: Hero? {
        didSet {
            heroParams.removeAll()
            let heroAttributes = Hero.entity().attributesByName
            for attribute in heroAttributes {
                heroParams[attribute.key] = attribute.value
            }
        }
    }
    
    public var heroParams: Dictionary<String,Any> {
        get {
            var params = Dictionary<String,Any>()
            for attributeName in Hero.entity().attributesByName {
                params[attributeName.key] = nil
            }
            return params
        }
        set {}
    }
    
}
