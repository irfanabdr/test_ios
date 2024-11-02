//
//  NetworkManager.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import Foundation
import Alamofire

class ApiService {
    static let shared = ApiService()
    
    func getCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        let url = "https://quipper.github.io/native-technical-exam/playlist.json"
        AF.request(url).responseDecodable(of: [Course].self) { response in
            switch response.result {
            case .success(let courses):
                completion(.success(courses))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
