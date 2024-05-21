//
//  Item.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import UIKit
import CoreLocation

enum ItemType: Equatable {
    case returned
    case lost
    case found

    var color: UIColor {
        switch self {
        case .returned:
            return UIColor.returned
        case .lost:
            return UIColor.lost
        case .found:
            return UIColor.found
        }
    }

    var image: UIImage? {
        switch self {
        case .returned:
            return UIImage(systemName: "checkmark.seal")
        case .lost:
            return UIImage(systemName: "xmark.seal")
        case .found:
            return UIImage(systemName: "seal")
        }
    }

    var title: String {
        switch self {
        case .returned:
            return "Item recuperado"
        case .lost:
            return "Item perdido"
        case .found:
            return "Item achado"
        }
    }
}

struct Item: Equatable {
    var coordinate: CLLocationCoordinate2D
    var type: ItemType
    var description: String
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude.isEqual(to: rhs.latitude) && lhs.longitude.isEqual(to: rhs.longitude))
    }
}
