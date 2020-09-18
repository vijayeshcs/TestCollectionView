//
//  CustomCollectionViewCell.swift
//  LoudlyCollectionView
//
//  Created by Vijayesh on 18/09/20.
//  Copyright © 2020 Vijayesh. All rights reserved.
//

import UIKit
// Custom cell for UICollectionView . It is useful as we do not have to change the controller in storyboard or if there are too many element in the cell it gets messy in storyboard
class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameOfRepository: UILabel!
    @IBOutlet weak var login_Name: UILabel!
    @IBOutlet weak var size: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
