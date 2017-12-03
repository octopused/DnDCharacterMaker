//
//  ClassSelectionViewController.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 14.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import CoreData

class ClassSelectionViewController: UITableViewController {
    
    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var heroClasses: [HeroClass] = [] {
        didSet{ tableView.reloadData() }
    }
    let cellIdentifier = "HeroClassCell"
    
    public var hero: Hero?
    
    func getHeroClasses() {
        self.heroClasses = HeroClass.getAll(in: container.viewContext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHeroClasses()
        if let heroClass = hero?.heroClass {
            tableView.cellForRow(at: IndexPath(row: heroClasses.index(of: heroClass)!, section: 0))?.accessoryType = .checkmark
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroClasses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = heroClasses[indexPath.row].name
        cell.textLabel?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        cell.textLabel?.backgroundColor = UIColor.blue
        cell.accessoryType = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            for cell in tableView.visibleCells {
                cell.accessoryType = .none
            }
            cell.accessoryType = .checkmark
            hero?.heroClass = heroClasses[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }

}
