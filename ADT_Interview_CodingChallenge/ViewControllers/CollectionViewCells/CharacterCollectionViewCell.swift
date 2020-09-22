//
//  CharacterCollectionViewCell.swift
//  ADT_Interview_CodingChallenge
//
//  Created by Jeremy Fleshman on 9/22/20.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet var imageView: UIImageView! {
        didSet {
            configureImage()
        }
    }
    @IBOutlet var label: UILabel!

    fileprivate func configureImage() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 12

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2 - 16),
            imageView.heightAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}
