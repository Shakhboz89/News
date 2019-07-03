//
//  NewsCell.swift
//  News
//
//  Created by MacBook on 7/3/19.
//  Copyright © 2019 Shakhboz. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let newsTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsDescription: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 3
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    func configureCell(newsTitle: String, newsDescription: String) {
        self.newsTitle.text = newsTitle
        self.newsDescription.text = newsDescription
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        let labelsStackView = VerticalStackView(arrangedSubviews: [
            newsTitle, newsDescription, dateLabel
            ], spacing: 10)
        
        let infoStackView = UIStackView(arrangedSubviews: [
            newsImage, labelsStackView
            ])
        infoStackView.spacing = 12
        infoStackView.alignment = .center
        
        addSubview(infoStackView)
        infoStackView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
