//
//  NetworkManager.swift
//  Unsplash
//
//  Created by Tanya on 13.02.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func getPhotos(page: Int, completion: @escaping (Result<[UnsplashPhoto], NetworkError>) -> Void)
    func searchPhotosByWord(page: Int, query: String, completion: @escaping (Result<SearchResponse, NetworkError>) -> Void)
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
    private let apiKey = "OGRIHBJ9-ljgbpHM-DR8VInn6hSapE-TErh--OcuUpA"
    // "KaCOFgOjrAfE77fcdCaSVmInB3BeMI5WQmm6o2IOvkE" - tvoi
    // "OGRIHBJ9-ljgbpHM-DR8VInn6hSapE-TErh--OcuUpA" - moi
    
    func getPhotos(page: Int, completion: @escaping (Result<[UnsplashPhoto], NetworkError>) -> Void) {
        let endpoint = baseURL + "photos?per_page=30&page=\(page)&client_id=\(apiKey)"
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
                DispatchQueue.main.async {
                    completion(.success(photos))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func searchPhotosByWord(page: Int, query: String, completion: @escaping (Result<SearchResponse, NetworkError>) -> Void) {
        let endpoint = baseURL + "search/photos?per_page=30&page=\(page)&query=\(query)&client_id=\(apiKey)"
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
                let decoder = JSONDecoder()
                let response = try decoder.decode(SearchResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func getPhoto(id: String, completion: @escaping (Result<UnsplashPhoto, NetworkError>) -> Void) {
        let endpoint = baseURL + "photos/\(id)?client_id=\(apiKey)"
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
                let photo = try JSONDecoder().decode(UnsplashPhoto.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(photo))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
