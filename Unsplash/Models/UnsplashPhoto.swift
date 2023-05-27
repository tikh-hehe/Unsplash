//
//  UnsplashPhoto.swift
//  Unsplash
//
//  Created by Tanya on 06.02.2023.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String
    let created_at: String
    let blur_hash: String?
    let downloads: Int?
    let urls: PhotoUrls
    let user: User
    let location: PhotoLocation?
    
    var isFavorite: Bool?
}

struct PhotoUrls: Codable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
    let small_s3: URL
}

struct User: Codable {
    let username: String
}

struct PhotoLocation: Codable {
    let city: String?
    let country: String?
}
