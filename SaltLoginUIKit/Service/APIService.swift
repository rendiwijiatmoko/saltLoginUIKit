//
//  APIService.swift
//  SaltLoginUIKit
//
//  Created by Rendi Wijiatmoko on 18/11/22.
//

import Foundation

import Foundation

class APIService {
    
    func signin(modelRequest: CredentialModel, completion: @escaping(Result<ResponseModel, APIError>) -> Void) {
        guard let url = URL(string: "https://reqres.in/api/login") else {
            return
        }
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(modelRequest) else {
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(Result.failure(APIError.urlSession(error as? URLError)))
                return
            }
            guard let data = data else {
                completion(Result.failure(APIError.unknown))
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299).contains(response.statusCode) else {
                completion(Result.failure(APIError.badResponse(400)))
                return
            }
            
            do{
                let result = try JSONDecoder().decode(ResponseModel.self, from: data)
                completion(Result.success(result))
            } catch {
                completion(Result.failure(.decoding(error as? DecodingError )))
            }
        }.resume()
    }
}
