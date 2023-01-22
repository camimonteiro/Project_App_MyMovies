//
//  MovieCell.swift
//  MoviesAPP
//
//  Created by Cami on 22/01/23.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var movieStackView: UIStackView = {
        let movieStackView = UIStackView(arrangedSubviews: [titleLabel, categoryLabel, ratingStackView])
        movieStackView.axis = .vertical
        movieStackView.spacing = 8
        movieStackView.translatesAutoresizingMaskIntoConstraints = false
        return movieStackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = Fonts.extraLarge(.bold).font
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.font = Fonts.small(.regular).font
        categoryLabel.textColor = .lightGray
        categoryLabel.numberOfLines = 1
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        return categoryLabel
    }()
    
    private lazy var posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        return posterImageView
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let ratingStackView = UIStackView(arrangedSubviews: [starImageView, ratingLabel])
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 8
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        return ratingStackView
    }()
    
    private lazy var starImageView: UIImageView = {
        let starImageView = UIImageView()
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.image = UIImage.init(systemName: "star")
        starImageView.tintColor = .yellow
        return starImageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = Fonts.medium(.regular).font
        ratingLabel.textColor = .white
        ratingLabel.numberOfLines = 1
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        return ratingLabel
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    func configure(with model: Movie) {
        titleLabel.text = model.name
        categoryLabel.text = model.genres?.joined(separator: ", ")
        ratingLabel.text = model.rating?.average?.toString()
        
        guard let image = model.image?.medium,
              let imageUrl = URL(string: image) else {
            return
        }
        
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: imageUrl)
    }
}

// MARK: - ViewCode

extension MovieCell: ViewCode {
    func buildHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(blurView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(movieStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            blurView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            movieStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            movieStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            movieStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            
            starImageView.widthAnchor.constraint(equalToConstant: 24),
            starImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: 150)
        heightConstraint.isActive = true
        heightConstraint.priority = UILayoutPriority.init(999)
    }
    
    func applyAdditionalChanges() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }
}
