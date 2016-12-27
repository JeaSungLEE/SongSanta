//
//  ViewController.swift
//  SongSanta
//
//  Created by 이재성 on 27/12/2016.
//  Copyright © 2016 이재성. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class SantaTrackerViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var presentRemainLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var timeRemainLabel: UILabel!
    private var mapManager: MapManager!
    private let realmManager = SantaRealmManager()
    private var notificationToken: NotificationToken?
    private var santa: Santa?
    
    private func update(with santa: Santa) {
        mapManager.update(with: santa)
        let activity = santa.activity.description
        let presentsRemaining = "\(santa.presentsRemaining)"
        DispatchQueue.main.async {
            self.activityLabel.text = activity
            self.presentRemainLabel.text = presentsRemaining
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapManager = MapManager(mapView: mapView)
        
        realmManager.logIn {
            // Be responsible in unwrapping!
            if let realm = self.realmManager.realm() {
                let santas = realm.objects(Santa.self)
                
                // Has Santa's info already been downloaded?
                if let santa = santas.first {
                    // Yep, so just use it
                    self.santa = santa
                    santa.addObserver(self)
                } else {
                    // Not yet, so get notified when it has been
                    self.notificationToken = santas.addNotificationBlock {
                        _ in
                        let santas = realm.objects(Santa.self)
                        if let santa = santas.first {
                            self.notificationToken?.stop()
                            self.notificationToken = nil
                            self.santa = santa
                            santa.addObserver(self)
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        santa?.removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let santa = object as? Santa {
            update(with: santa)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}



