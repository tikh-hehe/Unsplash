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
    func updatePage()
}

final class FeedPresenter: FeedPresenterProtocol {
        
    private weak var view: FeedVCProtocol?
    
    private let networkManager = NetworkManager.shared
    
    var photos: [UnsplashPhoto] = []
    private var isloading = false
    private var page = 1
    
    init(view: FeedVCProtocol) {
        self.view = view
    }
    
    func getPhotos() {
        networkManager.getPhotos(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photos):
                self.photos += photos
                self.view?.updateCollection()
            case .failure(let error):
                print(error)
                self.view?.showAlert()
            }
        }
    }
    
    func updatePage() {
        isloading = false
        if !isloading {
            isloading = true
            page += 1
            getPhotos()
        }
    }
}
