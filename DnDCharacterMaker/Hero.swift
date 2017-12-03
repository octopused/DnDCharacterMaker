//
//  Hero.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 04.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import CoreData

class Hero: NSManagedObject {
    
    public var fullName: String { return firstName ?? "" }
    
    class func addNew(with info: Dictionary<String,Any>, in context: NSManagedObjectContext) {
        let hero = Hero(context: context)
        for (key, value) in info {
            hero.setValue(value, forKey: key)
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save new Hero. \(error). \(error.userInfo)")
        }
    }

    class func getAll(in context: NSManagedObjectContext) -> [Hero] {
        let request: NSFetchRequest = Hero.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let heroes = try context.fetch(request) as [Hero]
            return heroes
        } catch let error as NSError {
            print("Could not fetch Heroes. \(error). \(error.userInfo)")
            return []
        }
    }
    
    class func delete(_ hero: Hero, in context: NSManagedObjectContext) {
        context.delete(hero)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not delete Hero. \(error). \(error.userInfo)")
        }
    }
    
    class func change(_ hero: Hero, with info: Dictionary<String,Any>, in context: NSManagedObjectContext) {
        for (key, value) in info {
            hero.setValue(value, forKey: key)
        }
        if hero.changedValues().count > 0 {
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not change Hero. \(error). \(error.userInfo)")
            }
        }
    }
    
    class func saveChangesIn(_ hero: Hero, in context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save hero. \(error). \(error.userInfo)")
        }
    }
}
