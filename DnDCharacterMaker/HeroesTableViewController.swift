//
//  HeroesTableViewController.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 04.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import CoreData

class HeroesTableViewController: UITableViewController {
    
    @IBAction func addNewHeroButton(_ sender: UIBarButtonItem) {
        Manager.shared.currentHero = nil
        Manager.shared.heroParams.removeAll()
        performSegue(withIdentifier: "toHeroEdit", sender: self)
    }
    
    let container: NSPersistentContainer = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer)!
    
    var heroes: [Hero] = [] {
        didSet { tableView.reloadData() }
    }
    var selectedHero: Hero?
    
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh.attributedTitle = NSAttributedString(string: "Refreshing")
        refresh.addTarget(self, action: #selector(getHeroes), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHeroes()
    }
 
    func getHeroes() {
        let context = self.container.viewContext
        self.heroes = Hero.getAll(in: context)
        if (refresh.isRefreshing) {
            refresh.endRefreshing()
        }
    }
    
    func deleteHero(_ hero: Hero) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] action in
            if self != nil {
                Hero.delete(hero, in: (self?.container.viewContext)!)
                self?.getHeroes()
            }
        })
        let noAction = UIAlertAction(title: "No", style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHero" {
            ((segue.destination as? UINavigationController)?.visibleViewController as? HeroEditViewController)?.hero = selectedHero
        }
        if segue.identifier == "toHeroEdit" {
            if let hero = selectedHero {
                ((segue.destination as? UINavigationController)?.visibleViewController as? HeroEditViewController)?.hero = hero
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath)
        if let heroCell = cell as? HeroesTableViewCell {
            heroCell.hero = heroes[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteHero(self.heroes[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedHero = heroes[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Manager.shared.currentHero = heroes[indexPath.row]
    }
    
}
