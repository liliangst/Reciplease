//
//  UIImageView+Kingfisher.swift
//  Reciplease
//
//  Created by Lilian Grasset on 19/07/2023.
//

import Foundation
import UIKit

extension UIImageView {
    /// Return an image downloaded from url
    func setImage(from url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url,
                         placeholder: UIImage(named: "RecipePlaceholder"))
    }
}
