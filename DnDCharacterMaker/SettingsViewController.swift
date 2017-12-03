//
//  SettingsTableViewController.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 07.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var settingItems: [String] = ["Classes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = settingItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settingItems[indexPath.row] == "Classes" {
            performSegue(withIdentifier: "toClassesSettings", sender: self)
        }
    }

}
