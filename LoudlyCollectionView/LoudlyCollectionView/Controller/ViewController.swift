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
    var dataManager = GitDataManager()
    
    var dataArrayForCell = [item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataManager.delegate = self
        dataManager.fetchWeather(cityName: "tetris")
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
        
        return dataArrayForCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.nameOfRepository.text = dataArrayForCell[indexPath.row].name
        cell.login_Name.text =  dataArrayForCell[indexPath.row].owner.login
        cell.size.text = String(dataArrayForCell[indexPath.row].size)
        
        if  dataArrayForCell[indexPath.row].has_wiki == true{
                   cell.backgroundColor = UIColor.systemTeal
               }else{
                   cell.backgroundColor = UIColor.systemIndigo
               }
        
        return cell
    }

}

extension ViewController: GitDataManagerDelegate {
    func didUpdateData(_ dataManager: GitDataManager, dataModel: DataModel) {
        DispatchQueue.main.async {
        
            self.dataArrayForCell = dataModel.arrOfGitData
            self.collectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
         print(error)
    }
    

}
