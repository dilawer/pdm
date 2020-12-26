//
//  SearchModel.swift
//  pdm
//
//  Created by Muhammad Aqeel on 23/12/2020.
//

import Foundation
struct SearchModel: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let categories: [Categorys]?
    let podcasts: [Podcasts]?
}

// MARK: - Category
struct Categorys: Codable {
    let categoryID: Int?
    let id:Int?
    let categoryName: String
    let categoryIcon: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case id = "id"
        case categoryName = "category_name"
        case categoryIcon = "category_icon"
    }
}

// MARK: - Podcast
struct Podcasts: Codable {
    let podcastID: Int
    let podcastName, podcastDuration, episodeName: String
    let podcastIcon: String

    enum CodingKeys: String, CodingKey {
        case podcastID = "podcast_id"
        case podcastName = "podcast_name"
        case podcastDuration = "podcast_duration"
        case episodeName = "episode_name"
        case podcastIcon = "podcast_icon"
    }
}
