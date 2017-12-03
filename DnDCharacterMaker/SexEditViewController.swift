//
//  SexEditViewController.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 25.10.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit

class SexEditViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "sexCell"
    
    var hero: Hero?
    
    let cells: [String] = [
        "Male",
        "Female"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hero = Manager.shared.currentHero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

extension SexEditViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.accessoryType = .none
        let label = UILabel(frame: (cell?.frame)!)
        label.text = cells[indexPath.row]
        cell?.addSubview(label)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let hero = hero {
            for cell in tableView.visibleCells {
                cell.accessoryType = .none
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            cell?.accessoryType = .checkmark
            hero.sex = cells[indexPath.row]
        } else {
            Manager.shared.heroParams["sex"] = cells[indexPath.row]
        }
    }
}
