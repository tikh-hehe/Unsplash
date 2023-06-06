//
//  StorageManager.swift
//  Unsplash
//
//  Created by tikh on 27.05.2023.
//

import Foundation

final class StorageManager {
    
    private enum Keys {
        static let favorites = "favorites"
    }
    
    static let shared = StorageManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    func getPhotos() -> [UnsplashPhoto] {
        guard let data = defaults.data(forKey: Keys.favorites) else { return [] }
        
        let photos = try? JSONDecoder().decode([UnsplashPhoto].self, from: data)
        return photos ?? []
    }
    
    func savePhoto(_ photo: UnsplashPhoto) {
        var photos = getPhotos()
        photos.append(photo)
        
        let data = try? JSONEncoder().encode(photos)
        defaults.set(data, forKey: Keys.favorites)
    }
    
    func savePhotos(_ pictures: [UnsplashPhoto]) {
        let data = try? JSONEncoder().encode(pictures)
        defaults.set(data, forKey: Keys.favorites)
    }
}
