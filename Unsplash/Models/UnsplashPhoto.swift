//
//  UnsplashPhoto.swift
//  Unsplash
//
//  Created by Tanya on 06.02.2023.
//

import Foundation

struct UnsplashPhoto: Decodable {
    let urls: PhotoUrls
}

struct PhotoUrls: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
    let small_s3: URL
}
