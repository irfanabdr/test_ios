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
    private let courseRepository = CourseRepository()
    
    func fetchCourses() {
        courseRepository.fetchCourses { [weak self] courses in
            DispatchQueue.main.async {
                self?.courses = courses
            }
        }
    }
}
