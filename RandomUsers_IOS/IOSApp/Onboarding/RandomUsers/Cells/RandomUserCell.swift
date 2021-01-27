//
//  RandomUserCell.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/15/21.
//

import UIKit
import Kingfisher

class RandomUserCell : BaseCell {
        
    var randomUser: RandomUserInfo? {
        didSet {
                
            guard let object = randomUser else {return}
            
            let url = URL(string: object.picture.large)
            let imageResource = ImageResource(downloadURL: url!)
            self.imageView.kf.setImage(with: imageResource)
            
            self.userNamelabel.text = "\(String(describing: object.name.first)) \(String(describing: object.name.last))"
            
            let capitilizedGender = object.gender.capitalizingFirstLetter()
            self.userInfoLabel.text = "\(String(describing: capitilizedGender)), \(String(describing: object.phone))"
            self.countryLabel.text = object.location.country
            
            let streetNumber = String(object.location.street.number)
            self.addressLabel.text = "\(streetNumber) \(String(describing: object.location.street.name)) \(String(describing: object.location.city))"
        }
    }
    
    
    var horizontalStackView = UIStackView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setFrame(.init(width: 85, height: 85))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 9
        return imageView
    }()
    
    private let userNamelabel: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 14)
        name.textAlignment = .left
        name.numberOfLines = 0
        name.textColor = .black
        return name
    }()
    
    private let userInfoLabel: UILabel = {
        let gender = UILabel()
        gender.font = .systemFont(ofSize: 12)
        gender.textAlignment = .left
        gender.textColor = .gray
        return gender
    }()
    
    private let countryLabel: UILabel = {
        let country = UILabel()
        country.font = .systemFont(ofSize: 12)
        country.textAlignment = .left
        country.textColor = .gray
        return country
    }()
    
    private let addressLabel: UILabel = {
        let address = UILabel()
        address.numberOfLines = 0
        address.font = .systemFont(ofSize: 12)
        address.textAlignment = .left
        address.textColor = .gray
        return address
    }()
    
    private let separatorView = UIView.createSeparatorView(withColor: .appLightGray)

    //
    //MARK: - Adding subviews
    //
    override func setupViews()  {
        super.setupViews()
        
        constructStackView()
        constructHierarchy()
        activateConstraints()
        
    }
    
    func constructStackView() {
        let imageStackView = VerticalStackView(arrangedSubviews: [UIView(),imageView,UIView()])

        let verticalStackView = VerticalStackView(arrangedSubviews: [userNamelabel,userInfoLabel,countryLabel,addressLabel], spacing: 4)
        verticalStackView.distribution = .fillEqually

        horizontalStackView = HorizontalStackView(arrangedSubviews: [imageStackView,verticalStackView], spacing: 4)
    }
    
    func constructHierarchy() {
        addSubview(horizontalStackView)
        addSubview(separatorView)
    }
    
    func activateConstraints() {
        activateConstraintsHorizontalStackView()
        activateConstraintsSeparatorView()
    }
    
    func activateConstraintsHorizontalStackView() {

        horizontalStackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    func activateConstraintsSeparatorView() {
        separatorView.setHeight(1)
        separatorView.anchor(top: horizontalStackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 16, bottom: 0, right: 16))
    }
}
