//
//  HeroesTableViewCell.swift
//  DnDCharacterMaker
//
//  Created by RuslanKa on 04.09.17.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import CoreData

class HeroesTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSex: UILabel!
    
    public var hero: Hero? {
        didSet { updateUI() }
    }
    
    private func updateUI() {
        guard hero != nil else { return }
        lbName.text = "\((hero?.firstName)!) \((hero?.secondName ?? ""))"
        switch hero?.sex {
        case "Male"?:
            lbSex.text = "♂"
        case "Female"?:
            lbSex.text = "♀"
        default:
            return
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
