//
//  FooterView.swift
//  images-search
//
//  Created by Мария Анисович on 16.11.2024.
//

import UIKit

final class FooterView: UIView {
    private lazy var licenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "APP License"
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.textColor = UIColor(hex: "430BE0")
        return label
    }()
    
    private lazy var commercialUseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.textColor = UIColor(hex: "#747474")
        label.text = "Free for commercial use"
        return label
    }()

    private lazy var attributionRequiredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.textColor = UIColor(hex: "#747474")
        label.text = "No attribution required"
        return label
    }()

    private lazy var rulesStackView = UIStackView(arrangedSubviews: [commercialUseLabel, attributionRequiredLabel])
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "430BE0").cgColor
        button.setTitle("Share", for: .normal)
        button.setTitleColor(UIColor(hex: "#2D2D2D"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 14)
        return button
    }()
    
    private lazy var cropButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor(hex: "#FFFFFF")
        button.tintColor = UIColor(hex: "2D2D2D")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "430BE0").cgColor
        button.setTitle("Crop", for: .normal)
        button.setTitleColor(UIColor(hex: "#2D2D2D"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 14)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(hex: "#FFFFFF")
        
        setupLicenseLabel()
        setupRulesStackView()
        setupShareButton()
        setupCropButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func setupLicenseLabel() {
        addSubview(licenseLabel)

        NSLayoutConstraint.activate([
            licenseLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            licenseLabel.widthAnchor.constraint(equalToConstant: 100),
            licenseLabel.heightAnchor.constraint(equalToConstant: 19),
            licenseLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
        ])
    }
    
    private func setupRulesStackView() {
        rulesStackView.translatesAutoresizingMaskIntoConstraints = false
        rulesStackView.axis = .vertical
        rulesStackView.spacing = 5
        rulesStackView.distribution = .fillEqually
        
        addSubview(rulesStackView)
                
        NSLayoutConstraint.activate([
            rulesStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            rulesStackView.topAnchor.constraint(equalTo: topAnchor, constant: 43),
            rulesStackView.widthAnchor.constraint(equalToConstant: 166),
            rulesStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupShareButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "icon_share")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        shareButton.configuration = configuration

        addSubview(shareButton)

        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            shareButton.widthAnchor.constraint(equalToConstant: 124),
            shareButton.heightAnchor.constraint(equalToConstant: 32),
            shareButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    func addShareButtonTarget(_ target: Any?, action: Selector) {
        shareButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setupCropButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "crop")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4
        cropButton.configuration = configuration

        addSubview(cropButton)

        NSLayoutConstraint.activate([
            cropButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 10),
            cropButton.widthAnchor.constraint(equalToConstant: 124),
            cropButton.heightAnchor.constraint(equalToConstant: 32),
            cropButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    func addCropButtonTarget(_ target: Any?, action: Selector) {
        cropButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
