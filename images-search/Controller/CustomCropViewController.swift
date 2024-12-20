//
//  CustomCropViewController.swift
//  images-search
//
//  Created by Мария Анисович on 27.11.2024.
//

import CropViewController
import UIKit

 final class CustomCropViewController: CropViewController {
    private var previousViewController: UIViewController!

    convenience init(image: UIImage, previousViewController: UIViewController) {
        self.init(image: image)

        self.previousViewController = previousViewController
    }
 }

 extension CustomCropViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

        cropViewController.dismiss(animated: true)

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
        previousViewController.present(alert, animated: true)
    }
 }
