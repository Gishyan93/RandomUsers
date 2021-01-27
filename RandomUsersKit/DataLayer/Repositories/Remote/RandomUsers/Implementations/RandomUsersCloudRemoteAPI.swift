
//
//  Created by Tigran Gishyan on 12/25/20.
//

import Foundation
import PromiseKit

public class RandomUsersCloudRemoteAPI: RandomUsersRemoteAPI {
    
    // MARK: - Properties
    let urlSession: URLSession
    let domain = "randomuser.me"
    
    // MARK: - Methods
    public init() {
        
        let config = URLSessionConfiguration.default
        
        config.httpAdditionalHeaders = ["Authorization": "Bearer"]
        self.urlSession = URLSession(configuration: config)
    }
    
   
    public func getRandomUsers() -> Promise<RandomUsers> {
        return Promise<RandomUsers> { seal in
            // Build URL
            let urlString = "https://\(domain)/api?seed=renderforest&results=20&page=1"
            guard let url = URL(string: urlString) else {
                seal.reject(RemoteAPIError.createURL)
                return
            }
            // Send Data Task
            urlSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    
                    switch httpResponse.statusCode {
                    case 500..<600:
                        seal.reject(RemoteAPIError.serverError)
                    default:
                        seal.reject(RemoteAPIError.httpError)
                    }
                  return
                }
                
                guard let data = data else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(RandomUsers.self, from: data)
                    seal.fulfill(searchResults)
                } catch let error as NSError {
                    seal.reject(error)
                }
            }.resume()
        }
    }
    
    
    public func getMoreUsers(pageNumber: String) -> Promise<RandomUsers> {
        return Promise<RandomUsers> { seal in
            // Build URL
            let urlString = "https://\(domain)/api?seed=renderforest&results=20&page=\(pageNumber)"
            guard let url = URL(string: urlString) else {
                seal.reject(RemoteAPIError.createURL)
                return
            }
            // Send Data Task
            urlSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    
                    switch httpResponse.statusCode {
                    case 500..<600:
                        seal.reject(RemoteAPIError.serverError)
                    default:
                        seal.reject(RemoteAPIError.httpError)
                    }
                  return
                }
                
                guard let data = data else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(RandomUsers.self, from: data)
                    seal.fulfill(searchResults)
                } catch let error as NSError {
                    seal.reject(error)
                }
            }.resume()
        }
    }
    
    
}

extension RemoteAPIError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .unknown:
            return "RandomUsers had a problem loading some data.\nPlease try again soon!"
        case .createURL:
            return "RandomUsers had a problem creating a URL.\nPlease try again soon!"
        case .httpError:
            return "RandomUsers had a problem loading some data.\nPlease try again soon!"
        case .passwordValidation:
            return "Some error"
        case .dublicateError:
            return "Some error"
        case .serverError:
            return "Some error"
        }
    }
}
