//
//  MenuItems.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-03.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import Foundation
import UIKit

struct MenuItems {
    let icon: UIImage
    let title: String?
    
    init(icon: UIImage, title: String) {
        self.icon = icon
        self.title = title
    }
}
