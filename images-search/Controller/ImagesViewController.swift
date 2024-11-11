//
//  PicturesViewController.swift
//  images-search
//
//  Created by Мария Анисович on 07.11.2024.
//

import UIKit

final class ImagesViewController: UIViewController {
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
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(hex: "#D2D2D2")
        return separator
    }()
    
    private var collectionView: UICollectionView!
    
    private var sortedPixabayResponse: PixabayResponse!
    var pixabayResponse: PixabayResponse!

    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        sortedPixabayResponse = PixabayResponse(total: pixabayResponse.total, hits: pixabayResponse.hits.sorted {
            if $0.previewHeight == $1.previewHeight {
                return $0.previewWidth > $1.previewWidth
            }
            return $0.previewHeight < $1.previewHeight
        })
        
        setupTextField()
        setupLogoLabel()
        setupCollectionView()
        setupSeparator()
    }
    
    private func setupTextField() {
        let imageView = UIImageView(frame: CGRect(x: 13, y: 5, width: 14, height: 14))
        imageView.image = UIImage(named: "icon_search")?.withRenderingMode(.alwaysTemplate)
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 24))
        imageContainerView.addSubview(imageView)
        textField.leftView = imageContainerView
        textField.leftViewMode = .always
        textField.tintColor = UIColor(hex: "#575757")
        
        textField.text = text

        view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            textField.widthAnchor.constraint(equalToConstant: 215),
            textField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupLogoLabel() {
        view.addSubview(logoLabel)

        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            logoLabel.widthAnchor.constraint(equalToConstant: 52),
            logoLabel.heightAnchor.constraint(equalToConstant: 52),
            logoLabel.rightAnchor.constraint(equalTo: textField.leftAnchor, constant: -16)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        layout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = CGSize(width: view.bounds.size.width, height: 29)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(hex: "#F6F6F6")
        
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCollectionReusableView")
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: "pictureCollectionViewCell")
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSeparator() {
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: view.topAnchor, constant: 123),
            separator.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedPixabayResponse.hits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
            headerView.configure(count: sortedPixabayResponse.total)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCollectionViewCell", for: indexPath) as? PictureCollectionViewCell else {
            fatalError("Unable to dequeue OperationCollectionViewCell")
        }
        cell.configure(urlString: sortedPixabayResponse.hits[indexPath.item].previewURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(CGFloat(sortedPixabayResponse.hits[indexPath.item].previewWidth), CGFloat(sortedPixabayResponse.hits[indexPath.item].previewHeight))
    }
}
