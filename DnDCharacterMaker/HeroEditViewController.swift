//
//  HeroCreationViewController.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 05.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import CoreData

class HeroEditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heroFirstNameControl: UITextField!
    @IBOutlet weak var heroSecondNameControl: UITextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var btnSaveControl: UIBarButtonItem!
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        if self.hero == nil {
            Hero.addNew(with: getHeroParams(), in: container.viewContext)
        } else if isHeroChanged() {
            //Hero.change(self.hero!, with: getHeroParams(), in: container.viewContext)
            Hero.saveChangesIn(hero!, in: container.viewContext)
        }
        self.dismiss(animated: true)
    }
    
    let container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var hero: Hero?
//    let cells: [((Hero?) -> String, String)] = [
//        ({"Name: \($0?.fullName ?? "")"}, "toNameEdit"),
//        ({"Sex: \($0?.sex ?? "")"}, "toSexEdit"),
//        ({"Class: \($0?.heroClass?.name ?? "")"}, "toClassEdit")
//    ]
    let cells: [(String, String)] = [
        ("Name: \(Manager.shared.heroParams["firstName"] ?? "") \(Manager.shared.heroParams["secontName"] ?? "")", "toNameEdit")
        ,("Sex: \(Manager.shared.heroParams["sex"] ?? "")", "toSexEdit")
        ,("Class: \(Manager.shared.heroParams["heroClass"] ?? "")", "toClassEdit")
    ]
    
    func updateUI() {
        if let hero = self.hero {
            heroFirstNameControl.text = hero.firstName
            heroSecondNameControl.text = hero.secondName
            switch hero.sex {
            case .some("Male"):
                genderControl.selectedSegmentIndex = 0// (true, forSegmentAt: 0)
            case .some("Female"):
                genderControl.selectedSegmentIndex = 1
            default:
                genderControl.setEnabled(true, forSegmentAt: 0)
            }
            setFormToReadMode()
        } else {
            setFormToSaveMode()
        }
        
    }
    
    func isHeroChanged() -> Bool {
        if hero != nil {
            if heroFirstNameControl.text != hero?.firstName {
                return true
            }
            if heroSecondNameControl.text != hero?.secondName {
                return true
            }
            if genderControl.selectedSegmentIndex == 0 && hero?.sex == "Female" {
                return true
            }
            if genderControl.selectedSegmentIndex == 1 && hero?.sex == "Male" {
                return true
            }
        }
        return false
    }
    
    func setFormToSaveMode() {
        btnSaveControl.isEnabled = true
    }
    func setFormToReadMode() {
        btnSaveControl.isEnabled = false
    }

    func showRequiredFields() {
        
    }
    func genderControlEndEditing() {
        if isHeroChanged() {
            setFormToSaveMode()
        }
    }
    
    func getHeroParams() -> Dictionary<String,Any> {
        var heroParams = Dictionary<String,Any>()
        let firstName: String = heroFirstNameControl.text ?? ""
        let secondName: String = heroSecondNameControl.text ?? ""
        let sex = genderControl.titleForSegment(at: genderControl.selectedSegmentIndex)
        heroParams["firstName"] = firstName
        heroParams["secondName"] = secondName
        heroParams["sex"] = sex
        return heroParams
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero = Manager.shared.currentHero
        heroFirstNameControl.delegate = self
        heroSecondNameControl.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        genderControl.addTarget(self, action: #selector(genderControlEndEditing), for: UIControlEvents.allEvents)
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if isHeroChanged() {
            setFormToSaveMode()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Manager.shared.currentHero = nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toClassSelection" {
            if let classSelectionVC = (segue.destination as? ClassSelectionViewController) {
                classSelectionVC.hero = hero
            }
        }
        if segue.identifier == "toNameEdit" {
            if let nameEditVC = (segue.destination as? NameEditViewController) {
                nameEditVC.hero = self.hero
            }
        }
        if segue.identifier == "toSexEdit" {
            if let sexEditVC = (segue.destination as? SexEditViewController) {
                sexEditVC.hero = self.hero
            }
        }
    }
}

extension HeroEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = self.view.backgroundColor
        if isHeroChanged() {
            setFormToSaveMode()
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}

extension HeroEditViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroInfoCell", for: indexPath) as UITableViewCell
        //let cellText = cells[indexPath.section].0(hero)
        let cellText = cells[indexPath.section].0
        cell.contentView.subviews.flatMap({ $0 as? UILabel}).first?.text = cellText
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueName = cells[indexPath.section].1
        performSegue(withIdentifier: segueName, sender: self)
    }
}
