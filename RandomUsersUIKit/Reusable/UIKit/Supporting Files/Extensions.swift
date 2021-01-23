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
    
    convenience init(text: String, textColor: UIColor, textAlignment: NSTextAlignment, font: UIFont, numberOfLines: NSInteger = 1, backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.backgroundColor = backgroundColor
    }
}

extension UIView {
    
    static func createSeparatorView(withColor color: UIColor) -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = color
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }
    
    /**
         Add subviews and make it prepared for AutoLayout.
         
         - Parameter views: The views to be added as subviews of current view.
         */
    public func addSubViews(_ views: [UIView]) {
            views.forEach({
    self.addSubview($0)
    $0.translatesAutoresizingMaskIntoConstraints = false
            })
        }
     
    
    
    public func removeSubViews(_ views: [UIView]) {
        views.forEach({
            //self.willRemoveSubview($0)
            self.removeFromSuperview()
        $0.translatesAutoresizingMaskIntoConstraints = false
                })
    }
}

/**
Create rounded image

- Parameter backgroundColor:
- Parameter image:
- Parameter borderColor:
- Parameter cornerRadius: Width and height will be calculated from cornerradius
- Parameter backgroundColor: The color to be created as an UIImage
*/
extension UIImageView {
    convenience init(backgroundColor: UIColor, image: UIImage, borderColor: CGColor, cornerRadius: CGFloat) {
        self.init(image: nil)
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds  = true
        self.setFrame(.init(width: 80, height: 80))
       
        self.image = #imageLiteral(resourceName: "mobile_icon")
    }
}


extension UIStackView {
    func addBackground(color: UIColor, cornerRadius: CGFloat) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = cornerRadius
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
