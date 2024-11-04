//
//  CourseDetailViewModel.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import Foundation
import Combine

class CourseDetailViewModel: ObservableObject {
    @Published var course: Course?
    var selectedTitle: String?
    private let courseRepository = CourseRepository()
    
    init(title: String) {
        selectedTitle = title
    }
    
    func fetchCourse() {
        if let title = selectedTitle {
            course = courseRepository.getCourse(by: title)
        }
    }
}
