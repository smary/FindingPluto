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
    static let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJ2OFJqeVF0MUNQUXg1QXBJSkJ3ZVlZb3U2SzdmYlBQYWxFNnJlbThRemJrSjVCWUZUSiIsImp0aSI6IjhiNTIyZDU5NzQwM2VmNDI3MzUyYWNhM2JlNjMyOTdlZTU1Y2U1MDA2YTYwZjljZmFkMGY2OTgwOTYxNWQwMzhhYWU2NTViZTc2NDI1NzhiIiwiaWF0IjoxNjY3MzEyMzQ5LCJuYmYiOjE2NjczMTIzNDksImV4cCI6MTY2NzMxNTk0OSwic3ViIjoiIiwic2NvcGVzIjpbXX0.Tokna2ovqrMKquHwOliLkZFgkzz2zZJXKnZ4Dya8RkYA3LA0JcTBi3--O5e5M1RcZ2FzniWhHXpKxNEhDwOipUfI2_P3Hf7a7SDdMSqhrg8lde2zDzxJcCrCKgqMwteQvbDeqjKIY_eyqDbPLWaAG1F1GolMvvC7hp4ulcbc7Hwfl8JNmo5J1YyZPkyJzijADaWItnV06_5GG80iKPEE0LGb7m6PmxNaaNoswrjl8METMYeJwH1L-8ZVYlk1e1P7C3W37D0tTfZLJmCoqC4cVYuPvX5c79kWRe82HgPmfBNfbjMFCzx6Y_269SMbGD14sACTPNtIvhXR52zJYWE97w"
    
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

    func getAnimalsList() -> Observable<AnimalsResponse> {
        let getAnimalsURL = URL(string: PetFinderAPIConstants.baseURL + PetFinderAPIConstants.paths["animals"]!)!
        //return fetchData(url: getAnimalsURL, token: PetFinderAPIConstants.accessToken)
        return loadData(url: getAnimalsURL, token: PetFinderAPIConstants.accessToken)
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

