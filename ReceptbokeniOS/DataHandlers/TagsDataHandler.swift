//
//  TagsDataHandler.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-23.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import Foundation
import Firebase

class TagsDataHandler {
    
    var generalTags: [String] = []
    var regionTags: [String] = []
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        self.regionTags = snapshotValue["Region"] as! [String]
        self.generalTags = snapshotValue["General"] as! [String]
    }
    
    
    
}
