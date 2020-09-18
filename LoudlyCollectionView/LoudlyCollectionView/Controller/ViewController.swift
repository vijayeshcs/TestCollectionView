//
//  ViewController.swift
//  LoudlyCollectionView
//
//  Created by Vijayesh on 18/09/20.
//  Copyright © 2020 Vijayesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
   
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! // activity indicator for loading api
    @IBOutlet var searchBar: UISearchBar! //search bar to search any repo
    @IBOutlet weak var collectionView: UICollectionView! //collectionview
    
    var dataManager = GitDataManager() // datamanager to manage api calls
    var dataArrayForCell = [item]()   // array of data to populate in collectionViewCells
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        dataManager.delegate = self
        dataManager.fetchJson(repoName: "tetris") //first call to repo tetris
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // registering the custom collectionViewCell with the CollectionView
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
    }
    
    // Delegate menthods for Search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           if self.searchBar.text != "" {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                dataManager.fetchJson(repoName: self.searchBar.text!)
                searchBar.endEditing(true)
           }
       }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    //Delegate menthods for CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 20)
        let height = width/2//ratio
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArrayForCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.nameOfRepository.text = "Name of Repository: "+dataArrayForCell[indexPath.row].name
        cell.login_Name.text =  "Login name: "+dataArrayForCell[indexPath.row].owner.login
        cell.size.text = "Size: " + String(dataArrayForCell[indexPath.row].size)
        
        // If a repo has wiki the background color is teal else the background color is indigo
        
        if  dataArrayForCell[indexPath.row].has_wiki == true{
                   cell.backgroundColor = UIColor.systemTeal
               }else{
                   cell.backgroundColor = UIColor.systemIndigo
               }
        
        return cell
    }

    
    // adjust the UI in both landscape and potrait mode
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}

// Delegate method to get the data and if any api error
extension ViewController: GitDataManagerDelegate {
    func didUpdateData(_ dataManager: GitDataManager, dataModel: DataModel) {
        DispatchQueue.main.async {
        
            self.dataArrayForCell = dataModel.arrOfGitData
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at:IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func didFailWithError(error: Error) {
         print(error)
    }
    

}
