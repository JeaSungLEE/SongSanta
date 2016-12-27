//
//  Stop.swift
//  SongSanta
//
//  Created by 이재성 on 27/12/2016.
//  Copyright © 2016 이재성. All rights reserved.
//

import Foundation
import RealmSwift

class Stop: Object {
    dynamic var location: Location?
    dynamic var time: Date = Date(timeIntervalSinceReferenceDate: 0)
    
    convenience init(location:Location, time: Date){
        self.init()
        self.location = location
        self.time = time
    }
}
