//
//  DataFromJson.swift
//  LoudlyCollectionView
//
//  Created by Vijayesh on 18/09/20.
//  Copyright © 2020 Vijayesh. All rights reserved.
//

import Foundation
// This file is structured in a way we can directly decode our JSON file with the the data we need. It is part of our model in MVC structure
struct GitData: Codable {
    let items: [item]
}

struct item: Codable {
    let size: Int
    let has_wiki: Bool
    let name : String
    let owner : Owner
}

struct Owner: Codable {
    let login : String
}
