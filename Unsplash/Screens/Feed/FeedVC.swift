//
//  FeedVC.swift
//  Unsplash
//
//  Created by Tanya on 05.02.2023.
//

import UIKit
import Nuke
import NukeExtensions

protocol FeedVCProtocol: AnyObject {
    func updateCollection()
    func showAlert()
}

final class FeedVC: UIViewController {
    
    private lazy var presenter: FeedPresenterProtocol = FeedPresenter(view: self)

    // MARK: - Views
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseID)
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
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = flowLayout
        view.addSubview(collectionView)
        presenter.getPhotos()
    }
}

// MARK: - FeedVCProtocol

extension FeedVC: FeedVCProtocol {
    func updateCollection() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Something went wrong", message: "Please, try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(ac, animated: true)
        }
    }
}

// MARK: - CollectionView Delegate & DataSource

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseID,
                                                      for: indexPath) as! FeedCell
        NukeExtensions.loadImage(with: presenter.photos[indexPath.row].urls.small, into: cell.imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == presenter.photos.count - 10 {
            presenter.updatePage()
        }
    }
}

// MARK: - FlowLayout

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
