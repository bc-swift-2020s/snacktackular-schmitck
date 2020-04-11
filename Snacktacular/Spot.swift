//
//  Spot.swift
//  Snacktacular
//
//  Created by Cooper Schmitz on 4/9/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

class Spot: NSObject, MKAnnotation {
  var name: String
  var address: String
  var coordinate: CLLocationCoordinate2D
  var averageRating: Double
  var numberOfReviews: Int
  var postingUserID: String
  var documentID: String
  
  var longitude: CLLocationDegrees {
    return coordinate.longitude
  }
  
  var latitude: CLLocationDegrees {
    return coordinate.latitude
  }
  
  var title: String? {
    return name
  }
  
  var subtitle: String? {
    return address
  }
  
  var dictionary: [String: Any] {
    return ["name": name, "address": address, "longitude": longitude, "latitude": latitude, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID]
  }
  
  init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
    self.name = name
    self.address = address
    self.coordinate = coordinate
    self.averageRating = averageRating
    self.numberOfReviews = numberOfReviews
    self.postingUserID = postingUserID
    self.documentID = documentID
  }
  
  convenience override init() {
    self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
  }
  
  convenience  init(dictionary: [String: Any]) {
    let name = dictionary["name"] as! String? ?? ""
    let address = dictionary["address"] as! String? ?? ""
    let longitude = dictionary["longitude"] as! Double? ?? 0.0
    let latitude = dictionary["latitude"] as! Double? ?? 0.0
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
    let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
    let postingUserID = dictionary["postingUserID"] as! String? ?? ""
    
    self.init(name: name, address: address, coordinate: coordinate, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documentID: "")
  }
  
  //when we call save data we can put braces behind until we have actually verified the data
  func saveData(completed: @escaping (Bool) -> ()) {
    let db = Firestore.firestore()
    //grab the userID
    guard let postingUserID = (Auth.auth().currentUser?.uid) else {
      print("***ErrorL Could not save data because we don't have a valid postingUserID")
      return completed(false)
    }
    //updating any value that we would not have had
    self.postingUserID = postingUserID
    //Create the dictionary representing what we want to save
    let dataToSave = self.dictionary
    //check to see if we have saved a record, we will have a documentID
    if self.documentID != "" {
      //this is where we want to work
      let reference = db.collection("spots").document(self.documentID)
      reference.setData(dataToSave) { error in
        if let error = error {
          print("***ERROR: Updating document \(self.documentID) \(error.localizedDescription)")
          completed(false)
        } else {
          print("Document updated with the ref ID \(reference.documentID)")
          completed(true)
        }
      }
    } else {
      var reference: DocumentReference? = nil
      reference = db.collection("spots").addDocument(data: dataToSave) { error in
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
