//
//  APICaller.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 07/11/23.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    
    func fetchDataFromURL(urlString: String, completion: @escaping (Result<QuestionResponse,Error>) -> Void){
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURLError))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(QuestionResponse.self, from: data)
                completion(.success(results))
            }
            catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
    
    enum APIError: Error {
        case invalidURLError
        case failedToGetData
    }
    
}
