//
//  NetworkManager.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import Foundation
import Alamofire
import Combine

class ApiService {
    static let shared = ApiService()
    
    func getCourses() -> AnyPublisher<[Course], Error> {
        let url = "https://quipper.github.io/native-technical-exam/playlist.json"
        return AF.request(url)
            .validate()
            .publishDecodable(type: [Course].self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
}
