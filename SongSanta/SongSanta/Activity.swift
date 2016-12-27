//
//  Activity.swift
//  SongSanta
//
//  Created by 이재성 on 27/12/2016.
//  Copyright © 2016 이재성. All rights reserved.
//

import Foundation

enum Activity: Int {
    case unknown = 0
    case flying
    case deliveringPresents
    case tendingToReindeer
    case eatingCookies
    case callingMrsClaus
}

extension Activity: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown:
            return "❔ We're not sure what Santa's up to right now…"
        case .callingMrsClaus:
            return "📞 Santa is talking to Mrs. Claus on the phone!"
        case .deliveringPresents:
            return "🎁 Santa is delivering presents right now!"
        case .eatingCookies:
            return "🍪 Santa is having a snack of milk and cookies."
        case .flying:
            return "🚀 Santa is flying to the next house."
        case .tendingToReindeer:
            return "𐂂 Santa is taking care of his reindeer."
        }
    }
}
