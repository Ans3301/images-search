//
//  NoDigitsTextField.swift
//  images-search
//
//  Created by Мария Анисович on 06.11.2024.
//

import UIKit

final class NoDigitsTextField: UITextField {
    private let textPadding = UIEdgeInsets(
        top: 0,
        left: 40,
        bottom: 0,
        right: 0
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textPadding)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.addShadow()
    }

    private func addShadow() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4).cgPath
        self.layer.shadowColor = UIColor(hex: "#000000").cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 3
    }
}

extension NoDigitsTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let stringWithoutNumbers = string.filter { char in
            !char.isNumber
        }

        if let currentText = textField.text, let stringRange = Range(range, in: currentText) {
            textField.text = currentText.replacingCharacters(in: stringRange, with: stringWithoutNumbers)
            return false
        }

        return true
    }
}
