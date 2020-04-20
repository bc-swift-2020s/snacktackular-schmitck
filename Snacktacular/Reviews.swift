//
//  Reviews.swift
//  Snacktacular
//
//  Created by Cooper Schmitz on 4/18/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
  var reviewArray: [Review] = []
  var db: Firestore!
  
  init() {
    db = Firestore.firestore()
  }
  //The listener is placed in ViewWillAppear
  func loadData(spot: Spot, completed: @escaping () -> ()) {
    guard spot.documentID != "" else {
      return
    }
    print(spot.documentID)
     //add snapshot listener
    db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
       //if we get any changes in spots the listner is going to go off
       guard error == nil else {
         print("***ERROR: adding the snapshot listerner \(error?.localizedDescription)")
         return completed()
       }
       //clear out spotArray, which is everything in our tableView, so there will be no duplicates
       self.reviewArray = []
       //there are querySnapshot documnets
       for document in querySnapshot!.documents {
         //loads a dictioKKnary up
         let review = Review(dictionary: document.data())
         review.documentID = document.documentID
         self.reviewArray.append(review)
       }
       completed()
     }
   }
  
  
}
