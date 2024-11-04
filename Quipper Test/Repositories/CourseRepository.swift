//
//  CourseRepository.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import Foundation
import CoreData
import Combine

class CourseRepository {
    private let apiService = ApiService.shared
    private let coreDataStack = CoreDataStack.shared
    
    func fetchCourses() -> AnyPublisher<[Course], Error> {
        return apiService.getCourses()
    }
    
    func getCachedData() -> [Course] {
        return getAllCourses().map { Course($0) }
    }
    
    func saveToCache(_ courses: [Course]) {
        deleteAllCourses(getAllCourses())
        
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
    
    func getCourse(by title: String) -> Course? {
        var course: Course?
        do {
            let fetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "title == %@", title
            )
            if let entity = try coreDataStack.context.fetch(fetchRequest).first {
                course = Course(entity)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return course
    }
    
    private func getAllCourses() -> [CourseEntity] {
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
}
