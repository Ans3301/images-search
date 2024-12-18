//
//  HeaderView.swift
//  images-search
//
//  Created by Мария Анисович on 11.11.2024.
//

import UIKit

final class HeaderView: UIView {
    private lazy var textField: NoDigitsTextField = {
        let textField = NoDigitsTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(hex: "#F6F6F6")
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "E2E2E2").cgColor
        textField.autocapitalizationType = .none
        textField.font = UIFont(name: "OpenSans-Regular", size: 14)
        textField.textColor = UIColor(hex: "#2D2D2D")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search images",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#747474")]
        )
        return textField
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "P"
        label.backgroundColor = UIColor(hex: "430BE0")
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.font = UIFont(name: "Pattaya-Regular", size: 32)
        label.textColor = UIColor(hex: "#FFFFFF")
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: "430BE0")
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(hex: "#FFFFFF")
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(hex: "#FFFFFF")
        
        setupTextField()
        setupBackButton()
        setupLogoLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        let imageView = UIImageView(frame: CGRect(x: 13, y: 5, width: 14, height: 14))
        imageView.image = UIImage(named: "icon_search")?.withRenderingMode(.alwaysTemplate)
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 24))
        imageContainerView.addSubview(imageView)
        textField.leftView = imageContainerView
        textField.leftViewMode = .always
        textField.tintColor = UIColor(hex: "#575757")
        
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            textField.widthAnchor.constraint(equalToConstant: 215),
            textField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupBackButton() {
        addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            backButton.widthAnchor.constraint(equalToConstant: 52),
            backButton.heightAnchor.constraint(equalToConstant: 52),
            backButton.rightAnchor.constraint(equalTo: textField.leftAnchor, constant: -16)
        ])
    }
    
    private func setupLogoLabel() {
        addSubview(logoLabel)

        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            logoLabel.widthAnchor.constraint(equalToConstant: 52),
            logoLabel.heightAnchor.constraint(equalToConstant: 52),
            logoLabel.leftAnchor.constraint(equalTo: textField.rightAnchor, constant: 16)
        ])
    }
    
    func setText(text: String?) {
        textField.text = text
    }
    
    func addBackButtonTarget(_ target: Any?, action: Selector) {
        backButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
