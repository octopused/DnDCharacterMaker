//
//  NameEditViewController.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 25.10.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit

class NameEditViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    
    public var hero: Hero?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = hero?.firstName
        secondNameTextField.text = hero?.secondName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let hero = Manager.shared.currentHero {
            if hero.firstName != firstNameTextField.text {
                hero.firstName = firstNameTextField.text
            }
            if hero.secondName != secondNameTextField.text {
                hero.secondName = secondNameTextField.text
            }
        } else {
            Manager.shared.heroParams["firstName"] = firstNameTextField.text
            Manager.shared.heroParams["secondName"] = secondNameTextField.text
        }
    }
}
