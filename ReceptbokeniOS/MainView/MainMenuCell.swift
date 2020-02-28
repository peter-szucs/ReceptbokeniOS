//
//  MainMenuCell.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-03.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit

class MainMenuCell: UITableViewCell {
    
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    @IBOutlet weak var menuIconImage: UIImageView!
    
    
    func setMenu(menu: MenuItems) {
        menuTitleLabel.text = menu.title
        menuIconImage.image = menu.icon
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        

        // Configure the view for the selected state
    }

}
