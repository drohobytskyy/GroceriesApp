//
//  Product.swift
//  FireStoreApp
//
//  Created by @rtur drohobytskyy on 03/02/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import FirebaseFirestore
import Firebase

class Product {
    
    var id : String?
    var name : String?
    var checked : Bool?
    var user_id : String?
    
    init?(id: String, name: String, user_id: String) {
        
        self.id = id
        self.name = name
        self.user_id = user_id
        self.checked = false
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        
        self.id = snapshot.documentID
        var snapshotValue = snapshot.data()
        self.name = snapshotValue["name"] as? String
        self.user_id = snapshotValue["user_id"] as? String
        self.checked = snapshotValue["checked"] as? Bool
    }
    
}
