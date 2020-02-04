//
//  API.swift
//  FireStoreApp
//
//  Created by @rtur drohobytskyy on 31/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class API {
    
    static let shared: API = API()
    
    var products: [Product] = []
    
    private var db: Firestore! = Firestore.firestore()
    
    // load products sample
    func loadSampleProducts() -> [Product] {
        
        let firebaseAuth = Auth.auth()
        let user_id = firebaseAuth.currentUser?.uid
        
        var sampleProductNames: [String] = ["Bread", "Milk", "Juice", "Fruits", "Coffee", "Tea", "Meat", "Fish", "Beer"]
        
        for index in 0...8 {
            
            guard let product = Product(id: "\(index)", name: sampleProductNames[index], user_id: user_id ?? "1") else {
                return []
            }
            
            products.append(product)
        }
        
        return products
    }
    
    // MARK: - firebse crud
    // add document with auto-generated id
    func addProductDocumentGeneretedId(product: Product?) {
        
        guard let product = product else { return }
        
        db.collection("products").addDocument(data: ["id": product.id!, "name": product.name!, "checked": product.checked!, "active": true]) { (error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success")
            }
        }
    }
    
    // add document with specific id
    func addProductDocument (product: Product?) {
        
        guard let product = product else { return }
        
        db.collection("products").document(product.id!).setData(["id" : product.id!, "name": product.name!, "checked": product.checked!]) { (error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success")
            }
        }
    }
    
    // update document
    func updateProductDocument(product: Product?) {
        
        guard let product = product else { return }
        
        db.collection("products").document(product.id!).setData(["id" : product.id!, "name": product.name!, "checked": product.checked!], merge: true) { (error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success")
            }
        }
    }
    
    // delete document
    func deleteDocument(id: String) {
        
        db.collection("products").document(id).delete() { (error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success")
            }
        }
    }
    
    // delete single field
    func deleteField(fieldName: String) {
        
        db.collection("products").document("name").updateData([fieldName: FieldValue.delete()]) { (error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success")
            }
        }
    }
    
    // read document
    func getDocumentById(id: String) {
        
        db.collection("products").document(id).getDocument { (document, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let document = document {
                    if document.exists {
                        let docData = document.data()
                        print(docData ?? "")
                    } else {
                        print("document doesn't exist")
                    }
                } else {
                    print("could not get document")
                }
            }
        }
    }
    
    // read documents
    func getAllProductDocuments(completion: @escaping () -> Void ) {
                
        db.collection("products").getDocuments { (documents_data, error) in
            if let error = error {
                
                print(error.localizedDescription)
            } else {
                
                if let documents_data = documents_data {
                    
                    for document in documents_data.documents {
                        
                        let docData = document.data()
                        print(docData)
                        let product = Product(snapshot: document)
                        self.products.append(product)
                    }
                    
                } else {
                    print("no docs")
                }
                
                completion()
            }
        }
    }
    
    // filter documents
    func getFilteredDocumentsByUserID(user_id: String, completion: @escaping () -> Void) {
        
        db.collection("products").whereField("user_id", isEqualTo: user_id).getDocuments { (documents_data, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                if let documents_data = documents_data {
                    
                    for document in documents_data.documents {
                        
                        let docData = document.data()
                        print(docData)
                        
                        let product = Product(snapshot: document)
                        self.products.append(product)
                    }
                } else {
                    print("no docs")
                }
                
                completion()
            }
        }
    }
    
    // MARK: - logout
    func logout(transitionToInitialController: @escaping () -> Void) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            transitionToInitialController()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

