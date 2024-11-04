//
//  CourseViewModel.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import Foundation
import Combine

class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var state: AppState = .inital
    
    private let courseRepository = CourseRepository()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCourses() {
        state = .loading
        
        let cachedData = courseRepository.getCachedData()
        if !cachedData.isEmpty {
            courses = cachedData
            state = .success
        }
        
        courseRepository.fetchCourses()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(_) = completion {
                    if cachedData.isEmpty {
                        self.state = .error("No course available.")
                    }
                }
            } receiveValue: { courses in
                self.courseRepository.saveToCache(courses)
                self.courses = courses
                self.state = .success
            }
            .store(in: &cancellables)
    }
}
