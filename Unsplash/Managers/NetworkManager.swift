//
//  NetworkManager.swift
//  Unsplash
//
//  Created by Tanya on 13.02.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func getPhotos(page: Int, completion: @escaping (Result<[UnsplashPhoto], NetworkError>) -> Void)
}

enum NetworkError: Error {
    case badURL
    case unableToComplete
    case unhandledResponse
    case invalidData
    case decodingError
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let baseURL = "https://api.unsplash.com/"
    
    func getPhotos(page: Int = 1, completion: @escaping (Result<[UnsplashPhoto], NetworkError>) -> Void) {
        let endpoint = baseURL + "photos?per_page=30&page=\(page)&client_id=KaCOFgOjrAfE77fcdCaSVmInB3BeMI5WQmm6o2IOvkE"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL))
            return
        }
                
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            if let response = (response as? HTTPURLResponse), response.statusCode != 200 {
                completion(.failure(.unhandledResponse))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
