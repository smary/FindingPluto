//
//  RequestsManager.swift
//  FindingPluto
//
//  Created by Mariana on 03.11.2022.
//

import Foundation
import RxSwift


protocol RequestsManagerProtocol {

    func fetchData<T: Decodable>(request: RequestProtocol, token: String) -> Observable<T>

}


class RequestsManager: RequestsManagerProtocol {

    let accessTokenManager: AccessTokenManagerProtocol
    
    init(accessTokenManager: AccessTokenManagerProtocol = AccessTokenManager(userDefaults: .standard) ) {
        self.accessTokenManager = accessTokenManager
    }
    
    func isAccessTokenValid() -> Bool {
        return accessTokenManager.isAccessTokenValid()
    }
    
    
    func fetchData<T: Decodable>(request: RequestProtocol, token: String) -> Observable<T> {
      return Observable<T>.create { observer -> Disposable in
          
          if let urlRequest = try? request.createURLRequest(authToken: token) {
          let task = URLSession.shared.dataTask(with: urlRequest ) { (data, response, error) in
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
          } else {
          
          return Disposables.create()
          }
      }
    }
    
}
