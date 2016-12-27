//
//  Location.swift
//  SongSanta
//
//  Created by 이재성 on 27/12/2016.
//  Copyright © 2016 이재성. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    convenience init(latitude: Double, longitude: Double){
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}


