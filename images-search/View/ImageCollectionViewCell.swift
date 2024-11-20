//
//  PictureCollectionViewCell.swift
//  images-search
//
//  Created by Мария Анисович on 07.11.2024.
//

import Kingfisher
import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: "C4C4C4")
        layer.cornerRadius = 5
        
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(urlString: String) {
        let url = URL(string: urlString)
        let roundCorner = RoundCornerImageProcessor(radius: .point(5), roundingCorners: .all)
        imageView.kf.setImage(
            with: url,
            options: [.processor(roundCorner)]
        )
    }
}
