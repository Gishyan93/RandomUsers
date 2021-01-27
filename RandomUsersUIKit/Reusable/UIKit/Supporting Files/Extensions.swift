//
//  Extensions.swift
//  Volinfo
//
//  Created by Tigran Gishyan on 10/25/20.
//

import UIKit
//
//MARK: - UIColor
//
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
//
// MARK: - UIButton
//
extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
    }
    
    convenience init(backgroundColor: UIColor, title: String, titleColor: UIColor, cornerRadius: CGFloat) {
        self.init(type: .system)
        self.backgroundColor = backgroundColor
        self.setTitle(title)
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = cornerRadius
    }
    /**
         Set button image for all button states
         
         - Parameter image: The image to be set to the button.
         */
    open func setImage(_ image: UIImage?) {
    for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
    self.setImage(image, for: state)
            }
        }
    /**
         Set button title for all button states
         
         - Parameter text: The text to be set to the button title.
         */
    open func setTitle(_ text: String?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
        self.setTitle(text, for: state)
            
        }
        
    }
}
//
//MARK: - UILabel
//
extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
    }
}

extension UIView {
    
    static func createSeparatorView(withColor color: UIColor) -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = color
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }
    
}
