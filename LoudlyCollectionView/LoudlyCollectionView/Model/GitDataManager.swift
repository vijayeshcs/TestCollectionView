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
       func didFailWithError(error: Error, message : String)
   }


// This struct is used for API calling and parsing JSON
struct GitDataManager{
    
    let dataURL = "https://api.github.com/search/repositories?"
    
        var delegate: GitDataManagerDelegate?
        
        func fetchJson(repoName: String, pageCount: Int) {
            let urlString = "\(dataURL)q=\(repoName)&page=\(pageCount)&per_page=10"
            performRequest(with: urlString)
        }
        
        // Api call made using NSURLSession
        func performRequest(with urlString: String) {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!, message: error!.localizedDescription)
                        return
                    }
                    if let safeData = data {
                        if let parsedJsonData = self.parseJSON(safeData) {
                            print(parsedJsonData)
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
                let item = decodedData.self
                let data = DataModel(arrOfGitData: item.items, totalCount: item.total_count)
                return data
            } catch {
                let json = NSString(data: JsonData, encoding: String.Encoding.utf8.rawValue)
                print(json!)
                //print(error)
                delegate?.didFailWithError(error: error, message:json! as String)
                return nil
            }
        }
        
        
        
}
