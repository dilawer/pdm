//
//  PodcastDetailsResponse.swift
//  pdm
//
//  Created by Muhammad Aqeel on 23/12/2020.
//

import Foundation
struct PodcastDetailsResponse: Codable {
    let data: DetailsDataClass?
}

// MARK: - DataClass
struct DetailsDataClass: Codable {
    let podcastName: String
    let podcastIcon: String
    let pods: [Pod]
    let moreLikeThis: [Podcasts]?

    enum CodingKeys: String, CodingKey {
        case podcastName = "podcast_name"
        case podcastIcon = "podcast_icon"
        case pods
        case moreLikeThis = "more_like_this"
    }
}

// MARK: - MoreLikeThi
struct MoreLikeThi: Codable {
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

// MARK: - Pod
struct Pod: Codable {
    let episodeID: Int
    let episodeName: String
    let episodeAuthor: String?
    let episodeFileLink: String
    let episodeDuration: String

    enum CodingKeys: String, CodingKey {
        case episodeID = "episode_id"
        case episodeName = "episode_name"
        case episodeAuthor = "episode_author"
        case episodeFileLink = "episode_file_link"
        case episodeDuration = "episode_duration"
    }
}
