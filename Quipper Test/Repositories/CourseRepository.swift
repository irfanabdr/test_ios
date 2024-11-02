//
//  CourseRepository.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import Foundation
import CoreData

class CourseRepository {
    private let apiService = ApiService.shared
    private let coreDataStack = CoreDataStack.shared
    
    func fetchCourses(completion: @escaping ([Course]) -> Void) {
        let cachedData = fetchCachedData()
        if !cachedData.isEmpty {
            completion(cachedData)
        }
        
        apiService.getCourses { result in
            switch result {
            case .success(let courses):
                self.saveToCache(courses)
                completion(courses)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    private func fetchAllCourses() -> [CourseEntity] {
        var entities = [CourseEntity]()
        do {
            let fetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
            entities = try coreDataStack.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return entities
    }
    
    private func deleteAllCourses(_ entities: [CourseEntity]) {
        for entity in entities {
            coreDataStack.context.delete(entity)
        }
        coreDataStack.save()
    }
    
    private func fetchCachedData() -> [Course] {
        return fetchAllCourses().map { Course($0) }
    }
    
    private func saveToCache(_ courses: [Course]) {
        deleteAllCourses(fetchAllCourses())
        
        for course in courses {
            let entity = CourseEntity(context: coreDataStack.context)
            entity.title = course.title
            entity.presenterName = course.presenterName
            entity.desc = course.description
            entity.thumbnailUrl = course.thumbnailURL
            entity.videoUrl = course.videoURL
            entity.videoDuration = Int32(course.videoDuration)
        }
        coreDataStack.save()
    }
}
