//
//  Santa.swift
//  SongSanta
//
//  Created by 이재성 on 27/12/2016.
//  Copyright © 2016 이재성. All rights reserved.
//

import Foundation
import RealmSwift

class Santa: Object {
    private dynamic var _currentLocation: Location?
    var currentLocation:Location {
        get {
            return _currentLocation ?? Location(latitude: 90, longitude: 180)
        }
        set {
            _currentLocation = newValue
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["currentLocation", "activity"]
    }
    
    let route = List<Stop>()
    
    private dynamic var _activity:Int = 0
    var activity: Activity {
        get {
            return Activity(rawValue: _activity)!
        }
        set {
            _activity = newValue.rawValue
        }
    }
    
    dynamic var presentsRemaining: Int = 0
    
    // We'll need to save these, or notifications won't be sent
    private var observerTokens = [NSObject: NotificationToken]()
    
    // This sets up observations to each of Santa's properties, plus properties of those
    func addObserver(_ observer: NSObject) {
        // Add a typical KVO observer to all the properties
        // One of these needs to generate the initial call, could be any of them
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation), options: .initial, context: nil)
        // Want to make sure we're observing the location's properties in case someone changes one manually
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.latitude), options: [], context: nil)
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.longitude), options: [], context: nil)
        
        addObserver(observer, forKeyPath: #keyPath(Santa._activity), options: [], context: nil)
        addObserver(observer, forKeyPath: #keyPath(Santa.presentsRemaining), options: [], context: nil)
        
        observerTokens[observer] = route.addNotificationBlock {
            // self owns this route, so it will always outlive this closure
            [unowned self, weak observer] changes in
            switch changes {
            case .initial:
                // Fake a KVO call, just to keep things simple
                observer?.observeValue(forKeyPath: "route", of: self, change: nil, context: nil)
            case .update:
                observer?.observeValue(forKeyPath: "route", of: self, change: nil, context: nil)
            case .error:
                fatalError("Couldn't update Santa's info")
            }
        }
    }
    
    func removeObserver(_ observer: NSObject) {
        observerTokens[observer]?.stop()
        observerTokens.removeValue(forKey: observer)
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation))
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.latitude))
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.longitude))
        removeObserver(observer, forKeyPath: #keyPath(Santa._activity))
        removeObserver(observer, forKeyPath: #keyPath(Santa.presentsRemaining))
    }
}

extension Santa {
    static func test() -> Santa {
        let santa = Santa()
        santa.currentLocation = Location(latitude: 37.566535, longitude: 126.977969)
        santa.activity = .deliveringPresents
        santa.presentsRemaining = 42
        return santa
    }
}
