//
//  FavoriteCell.swift
//  Unsplash
//
//  Created by tikh on 01.06.2023.
//

import UIKit
import Nuke
import NukeExtensions

final class FavoriteCell: UITableViewCell {
    
    static let reuseID = "CustomTableViewCell"
    
    // MARK: - Views
    
    private let photo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    
    func configurePhotoAndUsername(photo: URL, username: String) {
        NukeExtensions.loadImage(with: photo, into: self.photo)
        usernameLabel.text = username
    }
    
    // MARK: - Layout
    
    func setupUI() {
        contentView.addSubview(photo)
        contentView.addSubview(usernameLabel)
        
        photo.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(68)
            make.centerY.equalToSuperview()
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photo.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
}
