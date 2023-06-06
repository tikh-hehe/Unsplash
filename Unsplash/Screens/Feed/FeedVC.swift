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
    func searchBarEmpty() -> Bool
    func stopAnimatingIndicator()
}

final class FeedVC: UIViewController {
    
    private lazy var presenter: FeedPresenterProtocol = FeedPresenter(view: self)

    // MARK: - Views
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame:.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseID)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        return collectionView
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 2
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }()
    
    private let footerView: UIActivityIndicatorView = {
        let footerView = UIActivityIndicatorView(style: .large)
        return footerView
    }()
    
    private let searchController = UISearchController()
    
    // MARK: - Properties
    
    private var numberOfPages = 0
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        searchController.searchBar.placeholder = "Tap-tap here"
        searchController.searchBar.delegate = self
        searchController.searchBar.spellCheckingType = .no
        searchController.searchBar.searchTextField.keyboardType = .asciiCapable
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.automaticallyShowsCancelButton = true
        collectionView.collectionViewLayout = flowLayout
        presenter.getPhotos()
        addSubviews()
        makeConstraints()
    }
}

// MARK: - FeedVCProtocol

extension FeedVC: FeedVCProtocol {
    func updateCollection() {
        DispatchQueue.main.async {
            self.footerView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            self.present(Alerts.defaultAlert, animated: true)
        }
    }
    
    func searchBarEmpty() -> Bool {
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty ? true : false
    }
    
    func stopAnimatingIndicator() {
        footerView.stopAnimating()
    }
}

// MARK: - CollectionView Delegate & DataSource

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseID, for: indexPath) as! FeedCell
        guard presenter.photos.count - 1 >= indexPath.row else { return cell } // ---
        let photo = presenter.photos[indexPath.row]
        let placeholderImage = UIImage(blurHash: photo.blur_hash ?? Constants.defaultBlurHash, size: CGSize(width: 8, height: 8))
        let options = ImageLoadingOptions(placeholder: placeholderImage, transition: .fadeIn(duration: 0.25))
        NukeExtensions.loadImage(with: photo.urls.small, options: options, into: cell.imageView) { _ in }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let infoVC = InfoVC(photo: presenter.photos[indexPath.row])
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        footer.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        return footer
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 50)
    }
    
    // MARK: - Layout
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - ScrollView
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        guard let text = searchController.searchBar.text else { return }
        
        if offsetY > contentHeight - height && text.isEmpty {
            presenter.getPhotos()
            footerView.startAnimating()
            
        } else if offsetY > contentHeight - height && !text.isEmpty {
            print(text)
            numberOfPages += 1
            if numberOfPages >= presenter.totalPage { return }
            presenter.searchPhotosByWord(query: text)
            if presenter.photosFromPage.count == 30 {
                footerView.startAnimating()
            }
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

// MARK: - SearchBarDelegate

extension FeedVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let actualPosition = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
        guard let text = searchController.searchBar.text else { return }

        if actualPosition.y != 0 {
            scrollToTop()
            numberOfPages = 0
            presenter.resetPagesAndPhotos()
            presenter.searchPhotosByWord(query: text)

        } else {
            numberOfPages = 0
            presenter.resetPagesAndPhotos()
            presenter.searchPhotosByWord(query: text)
        }
       
        searchController.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !searchBarEmpty() {
            presenter.resetPagesAndPhotos()
            scrollToTop()
            
            presenter.getPhotos()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarEmpty() {
            presenter.resetPagesAndPhotos()
            presenter.getPhotos()
        }
    }
}

