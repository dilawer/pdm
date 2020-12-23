//
//  TrendingResponse.swift
//  pdm
//
//  Created by Muhammad Aqeel on 23/12/2020.
//

import Foundation
// MARK: - MicsResponse
struct MicsResponse: Codable {
    let data: DataMicClass?
}

// MARK: - DataClass
struct DataMicClass: Codable {
    let podcastOfTheWeek: PodcastOfTheWeek
    let trending, recommended, newRelease: [NewRelease]

    enum CodingKeys: String, CodingKey {
        case podcastOfTheWeek = "podcast_of_the_week"
        case trending, recommended, newRelease
    }
}

// MARK: - NewRelease
struct NewRelease: Codable {
    let podcastID: Int
    let podcastName: String
    let episodeDuration: String
    let episodeName: String
    let podcastIcon: String

    enum CodingKeys: String, CodingKey {
        case podcastID = "podcast_id"
        case podcastName = "podcast_name"
        case episodeDuration = "episode_duration"
        case episodeName = "episode_name"
        case podcastIcon = "podcast_icon"
    }
}



// MARK: - PodcastOfTheWeek
struct PodcastOfTheWeek: Codable {
    let id: Int
    let podcastName: String
    let userID, categoryID, podcastOfTheWeek, podcastIsFeatured: Int
    let podcastIcon: String
    let createdAt, updatedAt: String
    let podcastDescription: String?
    let adminApproval: Int

    enum CodingKeys: String, CodingKey {
        case id
        case podcastName = "podcast_name"
        case userID = "user_id"
        case categoryID = "category_id"
        case podcastOfTheWeek = "podcast_of_the_week"
        case podcastIsFeatured = "podcast_is_featured"
        case podcastIcon = "podcast_icon"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case podcastDescription = "podcast_description"
        case adminApproval = "admin_approval"
    }
}
