//
//  MapDataAdapter.swift
//  Mapdemo
//
//  Created by Ali Al sharefi on 26/03/2020.
//  Copyright © 2020 Ali Al sharefi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit

class MapDataAdapter {
    
    static func getMKAnnotationsFromData(snap:QuerySnapshot) -> [MKPointAnnotation] {
        var markers = [MKPointAnnotation]() // create an empty list
              for doc in snap.documents {
                  print("received data: ")
                  let map = doc.data() // the data is delivered in a map
                  let text = map["text"] as! String
                  let geoPoint = map["coordinates"] as! GeoPoint
                  let mkAnnotation = MKPointAnnotation()
                  mkAnnotation.title = text
                  let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                  mkAnnotation.coordinate = coordinate
                  markers.append(mkAnnotation)
              }
        return markers
    }
    
}
