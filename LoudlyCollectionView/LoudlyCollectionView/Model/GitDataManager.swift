//
//  GitDataManager.swift
//  LoudlyCollectionView
//
//  Created by Vijayesh on 18/09/20.
//  Copyright © 2020 Vijayesh. All rights reserved.
//

import Foundation

// This is the networking file which will help to fetch the data from the api


// The protocol is used to return back the data to the controller
protocol GitDataManagerDelegate {
       func didUpdateData(_ dataManager: GitDataManager, dataModel: DataModel)
       func didFailWithError(error: Error)
   }


// This struct is used for API calling and parsing JSON
struct GitDataManager{
    
    let dataURL = "https://api.github.com/search/repositories?"
    
        var delegate: GitDataManagerDelegate?
        
        func fetchJson(repoName: String) {
            let urlString = "\(dataURL)q=\(repoName)"
            performRequest(with: urlString)
        }
        
        // Api call made using NSURLSession
        func performRequest(with urlString: String) {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data {
                        if let parsedJsonData = self.parseJSON(safeData) {
                            self.delegate?.didUpdateData(self, dataModel: parsedJsonData)
                        }
                    }
                }
                task.resume()
            }
        }
        
        // JSON Parsing method
        func parseJSON(_ JsonData: Data) -> DataModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(GitData.self, from: JsonData)
                let item = decodedData.items
                
                
                let data = DataModel(arrOfGitData: item)
                print(item)
                return data
                
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
        
        
        
}
