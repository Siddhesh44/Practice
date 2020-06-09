//
//  CarouselCell.swift
//  Practice
//
//  Created by Siddhesh jadhav on 26/05/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var foreGroundImage: UIImageView!
    
    override func awakeFromNib() {
        backGroundImage.image = foreGroundImage.image
    }
}
