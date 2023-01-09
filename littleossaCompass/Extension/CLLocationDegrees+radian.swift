//
//  CLLocationDegrees+Extension.swift
//  littleossaCompass
//

import CoreLocation

extension CLLocationDegrees {
    
    /// selfをラジアンに変換した値
    var radian: Double {
        return self * .pi / 180
    }
}
