//
//  LilossaCoordinateAPI.swift
//  littleossaCompass
//
//

import Foundation

struct LiLossaCoordinateAPI {
    
    /// GET-  All Coordinates
    func fetchAllCoordinates() async throws -> [LilossaCoordinate] {
        guard let url = URL(string: "http://localhost:8080/littleossa_coordinates") else {
            fatalError("Unknown Error")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpStatus = response as? HTTPURLResponse else {
            fatalError("Response Error")
        }
        
        switch httpStatus.statusCode {
        case 200 ..< 400:
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let coordinates = try decoder.decode([LilossaCoordinate].self, from: data)
            print(coordinates)
            return coordinates
            
        default:
            fatalError("Status Error")
            break
        }
    }
    
    func fetchLatestCoordinate() async throws -> LilossaCoordinate? {
        let coordinates = try await fetchAllCoordinates()
        return coordinates.first
    }
}

