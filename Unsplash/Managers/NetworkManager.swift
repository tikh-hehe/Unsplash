//
//  NetworkManager.swift
//  Unsplash
//
//  Created by Tanya on 13.02.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.unsplash.com/"
    
    func getPhotos(completion: @escaping ([UnsplashPhoto]) -> Void) {
        let endpoint = baseURL + "photos?per_page=30&client_id=KaCOFgOjrAfE77fcdCaSVmInB3BeMI5WQmm6o2IOvkE"
        guard let url = URL(string: endpoint) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data {
                let photos = try! JSONDecoder().decode([UnsplashPhoto].self, from: data)
                completion(photos)
            }
        }.resume()
    }
}
