//
//  FeedPresenter.swift
//  Unsplash
//
//  Created by Tanya on 06.02.2023.
//

import Foundation

protocol FeedPresenterProtocol {
    var photos: [UnsplashPhoto] { get }
    var photosFromPage: [UnsplashPhoto] { get }
    var totalPage: Int { get }
    func getPhotos()
    func searchPhotosByWord(query: String)
    func resetPagesAndPhotos()
}

final class FeedPresenter: FeedPresenterProtocol {
        
    private weak var view: FeedVCProtocol?
    
    private let networkManager = NetworkManager.shared
    
    var photos: [UnsplashPhoto] = []
    var query: String = ""
    var page = 1
    var totalPage = 0
    var photosFromPage: [UnsplashPhoto] = []
    
    init(view: FeedVCProtocol) {
        self.view = view
    }
    
    func getPhotos() {
        print(page)
        if page == 0 { page = 1 }
        
        networkManager.getPhotos(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photos):
                self.photos += photos
                self.page += 1
                self.view?.updateCollection()
                
            case .failure(let error):
                print(error)
                self.view?.showAlert()
            }
        }
    }
    
    func searchPhotosByWord(query: String) {
        page += 1
        
        networkManager.searchPhotosByWord(page: page, query: query) { [weak self] result in
            
            guard let self else { return }
            switch result {
            case .success(let photos):
                self.totalPage = photos.total_pages
                print(self.totalPage)
                self.photosFromPage = photos.results
                self.photos += photos.results
                self.view?.updateCollection()
                
                print(self.photosFromPage.count)
            case .failure(let error):
                print(error)
                self.view?.showAlert()
            }
        }
    }
    
    func resetPagesAndPhotos() {
        page = 0
        photos = []
    }
}
