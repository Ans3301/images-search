//
//  ZoomScrollView.swift
//  images-search
//
//  Created by Мария Анисович on 19.11.2024.
//

import Kingfisher
import UIKit

final class ZoomScrollView: UIScrollView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupImageView()

        minimumZoomScale = 1
        maximumZoomScale = 10
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(url: String) {
        self.init(frame: .zero)

        let url = URL(string: url)
        imageView.kf.setImage(with: url)
    }

    private func setupImageView() {
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func getImageForShare() -> UIImage? {
        return imageView.image
    }
}

extension ZoomScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
