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
    var maxPageCount = 100 //max page count. Since the api allows only 1000 items and we are fetching 10 items per page.
    var pageCount = 1     // current page count
    var prevPageCount = 1 // previous page count to handle incase of api failure
    var repoName = "tetris" //default repo is tetris. store the current repo name.
    var prevRepoName = "tetris" // previous repo name stored in case of api failure or rate limit exceeded.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        dataManager.delegate = self
        dataManager.fetchJson(repoName: repoName, pageCount : pageCount) //first call to repo tetris
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
                self.prevPageCount = self.pageCount
                self.pageCount = 1
                self.prevRepoName = self.repoName
                self.repoName = self.searchBar.text!
                dataManager.fetchJson(repoName : repoName,  pageCount : pageCount)
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
        
        // Pagination implemented. It check the maximum elements it can load. Since Github allows only 1000 items for the api wihtout keys and login, we have restriced our max item to 1000 in advance.
        
        if indexPath.row == dataArrayForCell.count - 1 {
                   if pageCount < maxPageCount{
                       self.activityIndicator.isHidden = false
                       self.activityIndicator.startAnimating()
                       self.prevPageCount = self.pageCount
                       self.pageCount += 1
                       dataManager.fetchJson(repoName: repoName, pageCount: pageCount)
                       
                   }
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
            if self.pageCount > 1{
                self.dataArrayForCell += dataModel.arrOfGitData
            }else{
                self.dataArrayForCell = dataModel.arrOfGitData
            }
            if dataModel.totalCount < 1000{
                self.maxPageCount = (dataModel.totalCount)/10
            }
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
            if self.pageCount == 1{
                self.collectionView.scrollToItem(at:IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    func didFailWithError(error: Error, message: String) {
        
        DispatchQueue.main.async {
            
            self.pageCount = self.prevPageCount
            self.repoName = self.prevRepoName
            /*
             getting the error message if any returned by api
             
             {
             "message": "API rate limit exceeded for 81.66.159.239. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)",
             "documentation_url": "https://developer.github.com/v3/#rate-limiting"
             }
 
            */
 
            var errorMessageStr : String = error.localizedDescription
                if let data = message.data(using: .utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                        errorMessageStr = json!["message"] as! String
                        //print (errorMessageStr)
                    } catch {
                        print("Something went wrong")
                    }
                }
                let alert = UIAlertController(title: "Try Again in sometime", message: errorMessageStr, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil
                      ))
            
            self.present(alert, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
    }
    }
    

}
