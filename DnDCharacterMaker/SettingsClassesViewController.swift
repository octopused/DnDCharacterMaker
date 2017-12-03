//
//  SettingsClassesViewController.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 07.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import CoreData

class SettingsClassesViewController: UITableViewController {

    @IBAction func btnAddClass(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new class", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            let context = (self?.container.viewContext)!
            let newClass = HeroClass(context: context)
            newClass.name = alert.textFields?.first?.text
            do {
                try context.save()
                self?.getClasses()
            } catch let error as NSError {
                print("Could not add new class. \(error). \(error.userInfo)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        present(alert, animated: true)
    }
    
    var heroClasses: [HeroClass] = [] {
        didSet { tableView.reloadData() }
    }
    
    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func getClasses() {
        let context = container.viewContext
        let request: NSFetchRequest<HeroClass> = NSFetchRequest(entityName: HeroClass.entity().name!)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            try heroClasses = context.fetch(request) as [HeroClass]
        } catch let error as NSError {
            print("Could not get classes. \(error). \(error.userInfo)")
        }
    }
    
    func deleteHeroClass(_ heroClass: HeroClass) {
        let alert = UIAlertController(title: "Delete?", message: "", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
            let context = self?.container.viewContext
            context?.delete(heroClass)
            do {
                try context?.save()
            } catch let error as NSError {
                print("Could not delete class. \(error). \(error.userInfo)")
            }
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func editHeroClass(_ sender: UIButton) {
        if let heroClass = (sender.superview as? SettingsClassesCell)?.heroClass {
            let alert = UIAlertController(title: "Edit class", message: "", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                guard let heroClassName = alert.textFields?.first?.text else { return }
                heroClass.name = heroClassName
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            alert.addTextField { textField in
                textField.text = heroClass.name
            }
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getClasses()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroClasses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        if let heroClassCell = cell as? SettingsClassesCell {
            heroClassCell.heroClass = heroClasses[indexPath.row]
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteHeroClass(heroClasses[indexPath.row])
        }
    }
    

}
