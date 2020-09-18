//
//  GitDataManager.swift
//  LoudlyCollectionView
//
//  Created by Vijayesh on 18/09/20.
//  Copyright © 2020 Vijayesh. All rights reserved.
//

import Foundation

protocol GitDataManagerDelegate {
       func didUpdateData(_ dataManager: GitDataManager, dataModel: DataModel)
       func didFailWithError(error: Error)
   }

struct GitDataManager{
    
    let dataURL = "https://api.github.com/search/repositories?"
    
        var delegate: GitDataManagerDelegate?
        
        func fetchWeather(cityName: String) {
            let urlString = "\(dataURL)q=\(cityName)"
            performRequest(with: urlString)
        }
        
        
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
        
        func parseJSON(_ weatherData: Data) -> DataModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(GitData.self, from: weatherData)
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
