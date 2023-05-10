//
//  SearchResponse.swift
//  Unsplash
//
//  Created by tikh on 30.03.2023.
//

import Foundation

struct SearchResponse: Decodable {
    let total: Int
    let total_pages: Int
    let results: [UnsplashPhoto]
}
