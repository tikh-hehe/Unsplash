//
//  FeedVC.swift
//  Unsplash
//
//  Created by Tanya on 05.02.2023.
//

import UIKit
import Nuke
import NukeExtensions

final class FeedVC: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FeedCell.self,
                                forCellWithReuseIdentifier: FeedCell.reuseID)
        return collectionView
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 2
        layout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 10, right: spacing)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }()
    
    var photos: [UnsplashPhoto] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = flowLayout
        view.addSubview(collectionView)
        getPhotos()
    }
    
    func getPhotos() {
        NetworkManager.shared.getPhotos { [weak self] photos in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.photos = photos
                self.collectionView.reloadData()
            }
        }
    }
}

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseID,
                                                      for: indexPath) as! FeedCell
        NukeExtensions.loadImage(with: photos[indexPath.row].urls.small, into: cell.imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let padding = flowLayout.sectionInset.left * 2 + flowLayout.minimumInteritemSpacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - padding
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
