//
//  Review.swift
//  Snacktacular
//
//  Created by Cooper Schmitz on 4/18/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review {
  var title: String
  var text: String
  var rating: Int
  var reviewerUserID: String
  var date: Date
  var documentID: String
  
  
  var dictionary: [String: Any] {
    return ["title": title, "text": text, "rating": rating, "reviewerUserID": reviewerUserID, "date": date, "documentID": documentID]
  }
  
  init(title: String, text: String, rating: Int, reviewerUserID: String, date: Date, documentID: String) {
    self.title = title
    self.text = text
    self.rating = rating
    self.reviewerUserID = reviewerUserID
    self.date = date
    self.documentID = documentID
  }
  
  convenience init() {
    let currentUserID =  Auth.auth().currentUser?.email ?? "Unknown User"
    self.init(title: "", text: "", rating: 0, reviewerUserID: currentUserID, date: Date(), documentID: "")
  }
  
  
  convenience init(dictionary: [String : Any]) {
    let title = dictionary["title"] as! String? ?? ""
    let text = dictionary["text"] as! String? ?? ""
    let rating = dictionary["rating"] as! Int? ?? 0
    let reviewerUserID = dictionary["reviewerUserID"] as! String? ?? ""
    let firebaseDate = dictionary["date"] as! Timestamp? ?? Timestamp()
    let date = firebaseDate.dateValue()
    self.init(title: title, text: text, rating: rating, reviewerUserID: reviewerUserID, date: date, documentID: "")
  }
  
  func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
     let db = Firestore.firestore()
     //Create the dictionary representing what we want to save
     let dataToSave = self.dictionary
     //check to see if we have saved a record, we will have a documentID
     if self.documentID != "" {
       //this is where we want to work
      let reference = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
       reference.setData(dataToSave) { error in
         if let error = error {
           print("***ERROR: Updating document \(self.documentID) in spot \(spot.documentID) \(error.localizedDescription)")
           completed(false)
         } else {
           print("Document updated with the ref ID \(reference.documentID)")
           completed(true)
         }
       }
     } else {
       var reference: DocumentReference? = nil
      reference = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { error in
         if let error = error {
           print("***ERROR: Updating document \(self.documentID) \(error.localizedDescription)")
           completed(false)
         } else {
           print("Document updated with the ref ID \(reference?.documentID ?? "Unknown")")
           completed(true)
         }
       }
     }
   }
}
