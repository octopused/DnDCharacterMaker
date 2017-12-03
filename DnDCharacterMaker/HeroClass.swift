//
//  HeroClass.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 12.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import CoreData

class HeroClass: NSManagedObject {
    
    class func find(_ heroClassName: String, in context: NSManagedObjectContext) -> HeroClass? {
        let request: NSFetchRequest = HeroClass.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", argumentArray: [heroClassName])
        do {
            let heroClasses = try context.fetch(request) as [HeroClass]
            if heroClasses.count > 0 {
                return heroClasses[0]
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Could not find hero class. \(error).")
            return nil
        }
    }
    
    class func getAll(in context: NSManagedObjectContext) -> [HeroClass] {
        let request: NSFetchRequest = HeroClass.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(request) as [HeroClass]
        } catch let error as NSError {
            print("Could not get hero classes. \(error).")
            return []
        }
    }
    
}
