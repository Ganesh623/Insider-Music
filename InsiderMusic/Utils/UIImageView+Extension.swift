//
//  UIImageView+Extension.swift
//  InsiderMusic
//
//  Created by mac on 26/06/20.
//  Copyright © 2020 Ganesh iOS. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // downloads & sets image on image view
    func downloadAndSetImage(from url: String?) {
        self.image =  #imageLiteral(resourceName: "Image_placeholder")
        guard let imgUrl = URL(string: url ?? "") else { return }
        ///
        DispatchQueue.global().async { [weak self] in
            if let imgData = try? Data(contentsOf: imgUrl) {
                if let image = UIImage(data: imgData) {
                    DispatchQueue.main.async { self?.image = image }
                }
            }
        }
    }
}
