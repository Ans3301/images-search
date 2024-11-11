//
//  HeaderCollectionReusableView.swift
//  images-search
//
//  Created by Мария Анисович on 11.11.2024.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        label.textColor = UIColor(hex: "#000000")
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear

        setupCountLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCountLabel() {
        addSubview(countLabel)

        NSLayoutConstraint.activate([
            countLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(count: Int) {
        countLabel.text = String(count) + " Free Images"
    }
}
