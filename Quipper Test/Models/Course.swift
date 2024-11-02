//
//  Course.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import Foundation

struct Course: Codable {
    let title: String
    let presenterName: String
    let description: String
    let thumbnailURL: String
    let videoURL: String
    let videoDuration: Int
    
    init(_ entity: CourseEntity) {
        self.title = entity.title ?? ""
        self.presenterName = entity.presenterName ?? ""
        self.description = entity.desc ?? ""
        self.thumbnailURL = entity.thumbnailUrl ?? ""
        self.videoURL = entity.videoUrl ?? ""
        self.videoDuration = Int(entity.videoDuration)
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case presenterName = "presenter_name"
        case description = "description"
        case thumbnailURL = "thumbnail_url"
        case videoURL = "video_url"
        case videoDuration = "video_duration"
    }
}
