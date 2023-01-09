//
//  LilossaCoordinate.swift
//  littleossaCompass
//

import Foundation

struct LilossaCoordinate: Codable {
        
    let id: UUID
    /// 日付
    let createdAt: String
    /// 緯度
    let latitude: Double
    /// 経度
    let longitude: Double
}
