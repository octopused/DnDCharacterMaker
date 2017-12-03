//
//  SettingsClassesCell.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 12.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import CoreData

class SettingsClassesCell: UITableViewCell {

    @IBOutlet weak var lbHeroClassName: UILabel!
    @IBOutlet weak var tfHeroClassName: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBAction func btnDonePressed(_ sender: UIButton) {
        btnEdit.isHidden = false
        btnDone.isHidden = true
        btnCancel.isHidden = true
        tfHeroClassName.isHidden = true
        let newName = tfHeroClassName.text
        if newName != lbHeroClassName.text {
            heroClass?.name = newName
            do {
                try container.viewContext.save()
                updateUI()
            } catch let error as NSError {
                print("Could not change hero class. \(error). \(error.userInfo)")
            }
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        btnEdit.isHidden = false
        btnDone.isHidden = true
        btnCancel.isHidden = true
        tfHeroClassName.isHidden = true
    }
    
    @IBAction func btnEditPressed(_ sender: UIButton) {
        btnEdit.isHidden = true
        btnDone.isHidden = false
        btnCancel.isHidden = false
        tfHeroClassName.isHidden = false
        tfHeroClassName.text = lbHeroClassName.text
    }
    
    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    public var heroClass: HeroClass? { didSet{ updateUI() } }
    
    func updateUI() {
        guard heroClass != nil else { return }
        lbHeroClassName.text = heroClass?.name
    }

}
