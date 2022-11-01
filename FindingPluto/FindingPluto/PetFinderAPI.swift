//
//  PetFinderAPI.swift
//  FindingPluto
//
//  Created by Mariana on 31.10.2022.
//

import Foundation
import RxSwift

class PetFinderAPIConstants {
    
    static let client_id = "v8RjyQt1CPQx5ApIJBweYYou6K7fbPPalE6rem8QzbkJ5BYFTJ"
    static let client_secret = "IMauhBOrO6rHY2oaII2VwvZAjVbWlAeL2RcBCJYb"
    static let grant_type = "client_credentials"
    static let host = "api.petfinder.com"
    static let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJ2OFJqeVF0MUNQUXg1QXBJSkJ3ZVlZb3U2SzdmYlBQYWxFNnJlbThRemJrSjVCWUZUSiIsImp0aSI6IjBiYzAwZjg3NDM1N2YwNzY0ZWUxYjRiOWJiYTJmMGZlMzdlNzdmN2M2MzZlMzk3YWMyNWJhOTk0OTAyOTc5YmIzZTllZThjOTVhOGE4NTllIiwiaWF0IjoxNjY3Mjk4NDY2LCJuYmYiOjE2NjcyOTg0NjYsImV4cCI6MTY2NzMwMjA2Niwic3ViIjoiIiwic2NvcGVzIjpbXX0.MCREUIJwaec1zSkTiX40JWamp_ELqjLm8Pnvw05H4I8o8oQWZJgvcbh1yjWgUqvDVx7P___jcDkg0YU-6dCClLCIvsKs2GD5Jszg5Jukbi21HFRCNL-xeXyollkNcAtZhgKBsSF_kRrFsS2m1VoAdahdbMoZ_ncwG5NsJvHZpaWOr0DA71sN6NdJzbEDc8_wOvW_gj9uvfn94ORZZXDx8pB_EmYkh2-Q-6RhEVkv8PhpG6M0TtKPe5z_l22ev7uQBjeZP3Jikp3b4ebX6xDQDIP_DKTYED9P0fbeDyu-XUQHV1DfZzz02KS2rl1yzf8CCFh4qs-Y7Pea2HJe5OzZ5Q"
    
    static let baseURL = "https://api.petfinder.com"
    
    static let paths = [
        "acces_token" : "/v2/oauth2/token",
        "animals" : "/v2/animals"
    ]
    
    static let body_params = [
        "grant_type":grant_type,
        "client_id":client_id,
        "client_secret":client_secret
    ]
}

enum PetFinderAPIError: Error {
    
    case invalidRequest         // Status code 400
    case unauthorized           // Status code 401
}



class NetworkService {

    func getAnimals() -> Observable<AnimalsResponse> {
        let getAnimalsURL = URL(string: PetFinderAPIConstants.baseURL + PetFinderAPIConstants.paths["animals"]!)!
        //return executeRequest(url: getAnimalsURL, token: PetFinderAPIConstants.accessToken)
        return fetchData(url: getAnimalsURL, token: PetFinderAPIConstants.accessToken)
    }
    
    func fetchData<T: Decodable>(url: URL, token: String) -> Observable<T> {
      return Observable<T>.create { observer -> Disposable in
          var request = URLRequest(url: url)
          request.httpMethod = "GET"
          request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          
        let task = URLSession.shared.dataTask(with: request ) { (data, response, error) in
          do {
            let animalsResponse = try JSONDecoder().decode(T.self, from: data ?? Data())
            observer.onNext( animalsResponse )
          } catch let error {
            observer.onError(error)
          }
          observer.onCompleted()
        }
        task.resume()
        return Disposables.create {
          task.cancel()
        }
      }
    }
  
//    static let shared = NetworkService()
//
//    private init() {}
//
//    func createAccessTokenRequest() throws -> URLRequest {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = APIConstants.host
//        components.path = "/v2/oauth2/token"
//
//        guard let url = components.url else {
//            throw APIError.badRequest
//        }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.httpMethod = "POST"
//        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: APIConstants.body_params)
//        return urlRequest
//    }
//
//    func getAccessToken() async throws -> AccessToken {
//        let urlRequest = try createAccessTokenRequest()
//
//        let (data, httpResponse) = try await URLSession.shared.data(for: urlRequest)
//
//        guard let httpResponse = httpResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw APIError.badRequest
//        }
//
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        let results = try decoder.decode(AccessToken.self, from: data)
//        return results
//    }
}

