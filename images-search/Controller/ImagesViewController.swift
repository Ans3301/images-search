//
//  PicturesViewController.swift
//  images-search
//
//  Created by Мария Анисович on 07.11.2024.
//

import UIKit

final class ImagesViewController: UIViewController {
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(hex: "#D2D2D2")
        return separator
    }()
    
    private var collectionView: UICollectionView!
    
    var pixabayResponse: PixabayResponse!
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        setupHeaderView()
        setupCollectionView()
        setupSeparator()
    }
    
    private func setupHeaderView() {
        headerView.setText(text: text)
        headerView.addBackButtonTarget(self, action: #selector(backButtonTapped(_:)))
        
        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 116)
        ])
    }
    
    @objc private func backButtonTapped(_ button: UIButton) {
        dismiss(animated: true)
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
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCollectionViewCell")
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSeparator() {
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
            separator.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pixabayResponse.hits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
            headerView.configure(count: pixabayResponse.total)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Unable to dequeue OperationCollectionViewCell")
        }
        cell.configure(urlString: pixabayResponse.hits[indexPath.item].previewURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageViewController = ImageViewController()
        imageViewController.pixabayImage = pixabayResponse.hits[indexPath.item]
        imageViewController.modalPresentationStyle = .overFullScreen
        imageViewController.modalTransitionStyle = .crossDissolve
        present(imageViewController, animated: true)
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(CGFloat(pixabayResponse.hits[indexPath.item].previewWidth), CGFloat(pixabayResponse.hits[indexPath.item].previewHeight))
    }
}
