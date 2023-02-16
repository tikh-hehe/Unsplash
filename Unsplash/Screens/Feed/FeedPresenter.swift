//
//  FeedPresenter.swift
//  Unsplash
//
//  Created by Tanya on 06.02.2023.
//

import Foundation

protocol FeedPresenterProtocol {
    var photos: [UnsplashPhoto] { get }
    
    func getPhotos()
}

final class FeedPresenter: FeedPresenterProtocol {
        
    weak var view: FeedVCProtocol?
    
    private let networkManager = NetworkManager.shared
    
    var photos: [UnsplashPhoto] = []
    
    init(view: FeedVCProtocol) {
        self.view = view
    }
    
    func getPhotos() {
        networkManager.getPhotos { [weak self] photos in
            guard let self else { return }
            self.photos = photos
            self.view?.updateCollection()
        }
    }
}
