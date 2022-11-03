//
//  PetFinderAPI.swift
//  FindingPluto
//
//  Created by Mariana on 31.10.2022.
//

import Foundation
import RxSwift
import RxCocoa

class PetFinderAPIConstants {
    
    static let client_id = "v8RjyQt1CPQx5ApIJBweYYou6K7fbPPalE6rem8QzbkJ5BYFTJ"
    static let client_secret = "IMauhBOrO6rHY2oaII2VwvZAjVbWlAeL2RcBCJYb"
    static let grant_type = "client_credentials"
    static let host = "api.petfinder.com"
    static let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJ2OFJqeVF0MUNQUXg1QXBJSkJ3ZVlZb3U2SzdmYlBQYWxFNnJlbThRemJrSjVCWUZUSiIsImp0aSI6IjMxMzc4MzY2NmNlYmM2NDhjZTgwNGM4MGI2NTRlNThiNjA1MjNkYWUyMWI4M2ZkNmM4NTJlY2JhYjE4NjJhYzFlYWE2MzIxOTZhMDVlZWRiIiwiaWF0IjoxNjY3NDczMTg3LCJuYmYiOjE2Njc0NzMxODcsImV4cCI6MTY2NzQ3Njc4Nywic3ViIjoiIiwic2NvcGVzIjpbXX0.lYBJ8xexyPaKfRWSJRbvdA0kfu8Ss8sH2zrUS3Cx1BjaR5G8Gap-SnGNLC-frhO9a8ae-qmAQsVK--VYvOSI6Lqrk26MjIkjdAfr_EvIZ6nxd07mgsYyk_LifGXbtCv9pscZ4pgaDO9yYQFfgAnRTZj35M6k8H68yiyC1KZdvUO2xwQQMKP1KEFLp5gtyk1YOOnGsiXxb4SmLe8XnWX_7vloEhtKJSWcDmt657c2vJR_Gpv_SIF6o-wHRhAs6JkpsuKb6Xrivhx_xkkAHdKxaZhpS3ZfxpYUVhgLJDhZvolYnPbewq1-wnQBa7A4yOnxq9Slh6jwNLtjzr1lzaNM1A"
    
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

public enum NetworkError: Error {
    
    case invalidRequest         // Status code 400
    case unauthorized           // Status code 401
    case invalidResponse
    case invalidURL
    
    public var errorDescription: String? {
        switch self {
        case.invalidRequest:
            return "Invalid request."
        case .unauthorized:
            return "Invalid acces token."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is not valid."
        }
    }
    
}

class NetworkService {

    func getAnimalsList() -> /*Observable<AnimalsResponse>*/Observable<[Animal]> {
        let getAnimalsURL = URL(string: PetFinderAPIConstants.baseURL + PetFinderAPIConstants.paths["animals"]!)!
        let animalsResponseObservale: Observable<AnimalsResponse>  = fetchData(url: getAnimalsURL, token:  PetFinderAPIConstants.accessToken)
        let animals = animalsResponseObservale
            .map { animalsResult -> [Animal] in
                return animalsResult.animals ?? []
            }
        return animals
//        return fetchData(url: getAnimalsURL, token: PetFinderAPIConstants.accessToken)
        //return loadData(url: getAnimalsURL, token: PetFinderAPIConstants.accessToken)
    }
    
    
    func getAccessToken() -> Observable<String> {
        let urlString = PetFinderAPIConstants.baseURL + PetFinderAPIConstants.paths["acces_token"]!
        let requestAccessTokenURL = URL(string:  urlString)!
        let accessTokenObservale: Observable<AccessToken>  = fetchAccessToken (url: requestAccessTokenURL)
        let token = accessTokenObservale
            .map {$0.token ?? "" }
        return token
    }
    
    func fetchAccessToken<T: Decodable>(url: URL) -> Observable<T> {
      return Observable<T>.create { observer -> Disposable in
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
//          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          let bodyString   = "grant_type=client_credentials&client_id=" + PetFinderAPIConstants.client_id + "&client_secret=" + PetFinderAPIConstants.client_secret
          request.httpBody = bodyString.data(using: .utf8)
          
        let task = URLSession.shared.dataTask(with: request ) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Error: token request returns no data!")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                observer.onNext( decodedResponse )
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
    
    func fetchData<T: Decodable>(url: URL, token: String) -> Observable<T> {
      return Observable<T>.create { observer -> Disposable in
          var request = URLRequest(url: url)
          request.httpMethod = "GET"
          request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          
        let task = URLSession.shared.dataTask(with: request ) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                print("Error: Invalid response to token request!")
                return
            }
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if response.statusCode == 401 {
                //TODO: handle refreshToken
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data ?? Data())
                observer.onNext( decodedResponse )
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
    
    
    func loadData<T: Decodable>(url: URL, token: String) -> Observable<T> {
        return Observable.just(url)
            .flatMap { url -> Observable<Data> in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                return URLSession.shared.rx.data(request: request)
            }
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
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

