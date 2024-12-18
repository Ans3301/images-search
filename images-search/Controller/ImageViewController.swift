//
//  ImageViewController.swift
//  images-search
//
//  Created by Мария Анисович on 11.11.2024.
//

import CropViewController
import UIKit

final class ImageViewController: UIViewController {
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

    private lazy var footerView: FooterView = {
        let footerView = FooterView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()

    private var zoomScrollView: ZoomScrollView!

    var pixabayImage: PixabayImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#F6F6F6")

        setupHeaderView()
        setupZoomScrollView()
        setupSeparator()
        setupFooterView()
    }

    private func setupHeaderView() {
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
        dismiss(animated: true, completion: nil)
    }

    private func setupZoomScrollView() {
        zoomScrollView = ZoomScrollView(url: pixabayImage.webformatURL)
        zoomScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zoomScrollView)

        NSLayoutConstraint.activate([
            zoomScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 11),
            zoomScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zoomScrollView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            zoomScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -187)
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

    private func setupFooterView() {
        footerView.addShareButtonTarget(self, action: #selector(shareButtonTapped(_:)))
        footerView.addCropButtonTarget(self, action: #selector(cropButtonTapped(_:)))

        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 187)
        ])
    }

    @objc private func shareButtonTapped(_ button: UIButton) {
        guard let image = zoomScrollView.getImageForShare() else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .print
        ]

        present(activityViewController, animated: true, completion: nil)
    }

    @objc private func cropButtonTapped(_ button: UIButton) {
        guard let image = zoomScrollView.getImageForShare() else {
            return
        }

        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self

        present(cropViewController, animated: true, completion: nil)
    }
}

extension ImageViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func imageSaveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            showAlert(message: "Image saved successfully!")
        } else {
            showAlert(message: "Failed to save image.")
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Photo Save", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
