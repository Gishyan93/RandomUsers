//
//  SavedUserCell.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/21/21.
//

import UIKit
import Kingfisher

class SavedUserCell : BaseCell {
        
    var randomUser: Person? {
        didSet {
                
            guard let object = randomUser else {return}
            
            if let picture = object.picture,
               let firstName = object.firstname,
               let lastName = object.lastname,
               let gender = object.gender,
               let phone = object.phone,
               let country = object.country,
               let street = object.street,
               let city = object.city {
                
                guard let url = URL(string: picture) else {return}
                let imageResource = ImageResource(downloadURL: url)
                self.imageView.kf.setImage(with: imageResource)
                
                self.userNamelabel.text = "\(String(describing: firstName)) \(String(describing: lastName))"
                
                let capitilizedGender = gender.capitalizingFirstLetter()
                self.userInfoLabel.text = "\(String(describing: capitilizedGender)), \(String(describing: phone))"
                self.countryLabel.text = country
                
                let streetNumber = object.streetnumber
                self.addressLabel.text = "\(streetNumber) \(String(describing: street)) \(String(describing: city))"
            }
            
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setFrame(.init(width: 85, height: 85))
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
    
    private let cheapLevelLabel = UILabel(text: "", textColor: .black, textAlignment: .right, font: .systemFont(ofSize: 14), numberOfLines: 0)
    private let separatorView = UIView.createSeparatorView(withColor: .appLightGray)

    //
    //MARK: - Adding subviews
    //
    override func setupViews()  {
        super.setupViews()
        
        setupStackView()
    }
    
    
    
    private func setupStackView() {
        
        
        let verticalStackView = VerticalStackView(arrangedSubviews: [userNamelabel,userInfoLabel,countryLabel,addressLabel], spacing: 8)
        verticalStackView.distribution = .fillEqually
                
        let horizontalMiddleStackView = HorizontalStackView(arrangedSubviews: [imageView,verticalStackView], spacing: 4)
        
        
        let horizontalDownStackView = HorizontalStackView(arrangedSubviews: [UIView(), cheapLevelLabel], spacing: 8)
        
        
        let stackView = VerticalStackView(arrangedSubviews: [horizontalMiddleStackView,horizontalDownStackView,separatorView.setHeight(1)], spacing: 8)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 8, left: 16, bottom: 0, right: 16))
    }
}

