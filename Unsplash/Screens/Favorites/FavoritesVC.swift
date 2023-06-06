//
//  FavoritesVC.swift
//  Unsplash
//
//  Created by Tanya on 05.02.2023.
//

import UIKit

//protocol FavoritesVCProtocol: AnyObject {
//    func updateTableView()
//}

final class FavoritesVC: UIViewController {
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        
        return tableView
    }()
    
    // MARK: - Properties
    
    var photos = StorageManager.shared.getPhotos()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favorites"
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        photos = StorageManager.shared.getPhotos()
        let backText = UILabel()
        backText.text = "There are no favorites photos here.\n Add something!"
        backText.numberOfLines = 2
        backText.textAlignment = .center
        tableView.backgroundView = backText
        tableView.reloadData()
    }
    
    // MARK: - Layout
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
    }
}
    
    // MARK: - TableView Delegate & DataSource

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        cell.configurePhotoAndUsername(photo: photos[indexPath.row].urls.small, username: photos[indexPath.row].user.username)
        if tableView.numberOfRows(inSection: 0) != 0 {
            tableView.backgroundView = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          photos.remove(at: indexPath.row)
          StorageManager.shared.savePhotos(photos)
          tableView.deleteRows(at: [indexPath], with: .automatic)
          if tableView.numberOfRows(inSection: 0) == 0 {
              let backText = UILabel()
              backText.text = "There are no favorites photos here.\n Add something!"
              backText.numberOfLines = 2
              backText.textAlignment = .center
              tableView.backgroundView = backText
          }
      }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoVC = InfoVC(photo: photos[indexPath.row])
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
