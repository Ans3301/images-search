//
//  ViewController.swift
//  images-search
//
//  Created by Мария Анисович on 06.11.2024.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lighthouse-1209349_1920 1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.55)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Take your audience on a visual adventure"
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = UIFont(name: "OpenSans-ExtraBold", size: 26)
        label.textColor = UIColor(hex: "#FFFFFF")
        return label
    }()

    private lazy var textField: NoDigitsTextField = {
        let textField = NoDigitsTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(hex: "#FFFFFF")
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

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: "#430BE0")
        button.setTitle("Search", for: .normal)
        button.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        return button
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Photo by Free-Photos"
        label.textAlignment = .center
        label.font = UIFont(name: "OpenSans-Regular", size: 12)
        label.textColor = UIColor(hex: "#E5E5E5")
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundImageView()
        setupBackgroundView()
        setupTitleLabel()
        setupTextField()
        setupSearchButton()
        setupLabel()
    }

    private func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupBackgroundView() {
        view.addSubview(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 193),
            titleLabel.widthAnchor.constraint(equalToConstant: 335),
            titleLabel.heightAnchor.constraint(equalToConstant: 122),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupTextField() {
        let imageView = UIImageView(frame: CGRect(x: 13, y: 5, width: 14, height: 14))
        imageView.image = UIImage(named: "icon_search")?.withRenderingMode(.alwaysTemplate)
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 24))
        imageContainerView.addSubview(imageView)
        textField.leftView = imageContainerView
        textField.leftViewMode = .always
        textField.tintColor = UIColor(hex: "#575757")

        view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 378),
            textField.widthAnchor.constraint(equalToConstant: 343),
            textField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupSearchButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "icon_search")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        searchButton.configuration = configuration

        view.addSubview(searchButton)

        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 459),
            searchButton.widthAnchor.constraint(equalToConstant: 343),
            searchButton.heightAnchor.constraint(equalToConstant: 52),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        searchButton.addTarget(self, action: #selector(present(_:)), for: .touchUpInside)
    }

    @objc private func present(_ button: UIButton) {
        Task.detached {
            do {
                if let text = await self.textField.text {
                    let preparedString = text.trimmingCharacters(in: .whitespaces).lowercased()
                    let query = preparedString.replacingOccurrences(of: " ", with: "+")
                    let pixabayResponse = try await fetchImagesFromAPI(query: query)
                    await self.updatePixabayResponse(pixabayResponse: pixabayResponse)
                }
            } catch {}
        }
    }

    @MainActor
    private func updatePixabayResponse(pixabayResponse: PixabayResponse) {
        let imagesViewController = ImagesViewController()
        imagesViewController.pixabayResponse = sortPixabayResponse(pixabayResponse: pixabayResponse)
        imagesViewController.text = textField.text
        imagesViewController.modalPresentationStyle = .overFullScreen
        imagesViewController.modalTransitionStyle = .crossDissolve
        present(imagesViewController, animated: true)
    }
    
    private func sortPixabayResponse(pixabayResponse: PixabayResponse) -> PixabayResponse {
        let sortedPixabayResponse = PixabayResponse(total: pixabayResponse.total, hits: pixabayResponse.hits.sorted {
            if $0.previewHeight == $1.previewHeight {
                return $0.previewWidth > $1.previewWidth
            }
            return $0.previewHeight < $1.previewHeight
        })
        return sortedPixabayResponse
    }

    private func setupLabel() {
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            label.widthAnchor.constraint(equalToConstant: 125),
            label.heightAnchor.constraint(equalToConstant: 22),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
