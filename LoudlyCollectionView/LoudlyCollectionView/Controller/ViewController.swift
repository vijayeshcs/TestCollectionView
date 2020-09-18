//
//  ViewController.swift
//  LoudlyCollectionView
//
//  Created by Vijayesh on 18/09/20.
//  Copyright © 2020 Vijayesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let cellIdentifier = "CustomCollectionViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 20)
        let height = width //ratio
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.nameOfRepository.text = "123"
        cell.login_Name.text = "456"
        cell.size.text = "343"
        
        
        
        return cell
    }

}

