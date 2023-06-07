//
//  InfoVC.swift
//  Unsplash
//
//  Created by Tanya on 05.02.2023.
//

import UIKit
import Nuke
import NukeExtensions

final class InfoVC: UIViewController {
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    private let iconsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let usernameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    private let username: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let dateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar.circle")
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    private let createdAt: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let locationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "building.2.crop.circle")
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let location: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let downloadsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.down.circle")
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let downloads: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Properties
    
    let photo: UnsplashPhoto
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    
    init(photo: UnsplashPhoto) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.tintColor = .label
        activityIndicator.startAnimating()
        configureUI()
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let photos = StorageManager.shared.getPhotos()
        if photos.contains(where: { $0.id == photo.id }) {
            let image = UIImage(systemName: "heart.fill")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(buttonTapped))
        } else {
            let image = UIImage(systemName: "heart")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(buttonTapped))
        }
    }
    
    func configureUI() {
        NukeExtensions.loadImage(with: self.photo.urls.regular, into: self.imageView, completion: { _ in
            self.activityIndicator.stopAnimating()
        })
        
        self.username.text = "\(self.photo.user.username)"
        let date = self.photo.created_at.convertToDayMonthYear()
        self.createdAt.text = "\(date)"
        
        NetworkManager.shared.getPhoto(id: self.photo.id) { result in
            switch result {
            case .success(let response):
                if response.location?.country != nil {
                    self.iconsStackView.addArrangedSubview(self.locationImage)
                    self.labelsStackView.addArrangedSubview(self.location)
                    self.location.text = "Country: \((response.location?.country ?? "unknown")), City: \((response.location?.city ?? "unknown"))"
                }
                
                if response.downloads != nil {
                    self.iconsStackView.addArrangedSubview(self.downloadsImage)
                    self.labelsStackView.addArrangedSubview(self.downloads)
                    self.downloads.text = "Downloads: \(response.downloads ?? 0)"
                }
                
            case .failure(let failure):
                fatalError(failure.localizedDescription)
            }
                
        }
    }
    
    @objc private func buttonTapped(_ sender: UIBarButtonItem) {
        var photos = StorageManager.shared.getPhotos()
        if photos.contains(where: { $0.id == photo.id }) {
            sender.image = UIImage(systemName: "heart")
            photos.removeAll(where: { $0.id == photo.id })
            StorageManager.shared.savePhotos(photos)
            return
        }
        sender.image = UIImage(systemName: "heart.fill")
        StorageManager.shared.savePhoto(photo)
    }
    
    // MARK: - Layout
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        iconsStackView.addArrangedSubview(usernameImage)
        iconsStackView.addArrangedSubview(dateImage)
        labelsStackView.addArrangedSubview(username)
        labelsStackView.addArrangedSubview(createdAt)
        stackView.addArrangedSubview(iconsStackView)
        stackView.addArrangedSubview(labelsStackView)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(imageView)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
