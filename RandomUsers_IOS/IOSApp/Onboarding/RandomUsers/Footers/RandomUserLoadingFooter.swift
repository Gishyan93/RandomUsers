//
//  RandomUserLoadingFooter.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/17/21.
//

import UIKit

class RandomUserLoadingFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let aiv = UIActivityIndicatorView(style: .medium)
        aiv.color = .darkGray
        aiv.startAnimating()
        
        let label: UILabel = {
            let label = UILabel()
            label.text = "Loading..."
            label.font = .systemFont(ofSize: 16)
            label.textAlignment = .center
            return label
        }()
        
        let stackView = VerticalStackView(arrangedSubviews: [aiv,label], spacing: 8)
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 200, height: 0))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
