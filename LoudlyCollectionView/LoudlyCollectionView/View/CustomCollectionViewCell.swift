//
//  CustomCollectionViewCell.swift
//  LoudlyCollectionView
//
//  Created by Vijayesh on 18/09/20.
//  Copyright © 2020 Vijayesh. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameOfRepository: UILabel!
    @IBOutlet weak var login_Name: UILabel!
    @IBOutlet weak var size: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
