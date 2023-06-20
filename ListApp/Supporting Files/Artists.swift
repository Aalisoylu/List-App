//
//  Artists.swift
//  CocoPodsRequest
//
//  Created by Muhammed Ali SOYLU on 31.05.2023.
//

import Foundation

struct Artist: Codable {
    let results: [ArtistResults]?
}

struct ArtistResults: Codable {
    let trackName: String
    let artistName: String
    let artworkUrl60: String
    let country: String

}
