
//
//  Created by Tigran Gishyan on 12/4/20.
//

import PromiseKit

public struct CloudAuthenticationRemoteAPI: AuthRemoteAPI {
    //
    // MARK: - Properties
    //
    let domain = ""
    //
    // MARK: - Methods
    //
  
    public init() {}

  
    public func signIn(username: String, password: String) ->
    Promise<UserSession> {
        return Promise<UserSession> { seal in
            // Build Request
            var request = URLRequest(url: URL(string: "https://\(domain)/account/login")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let parameters: [String: Any] = [
                "email": username,
                "password": password
            ]
            let bodyData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = bodyData
            //let responseString = String(data: bodyData!, encoding: .utf8)
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
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
        
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let payload = try decoder.decode(SignInResponsePayload.self, from: data)
                        let remoteSession = RemoteUserSession(token: payload.token)
                        seal.fulfill(UserSession(error: payload.error, message: payload.message, remoteSession: remoteSession))
                    } catch {
                        seal.reject(error)
                    }
                } else {
                    seal.reject(RemoteAPIError.unknown)
                }
            }.resume()
        }
    }

  public func signUp(account: NewAccount) -> Promise<UserSession> {
    return Promise<UserSession> { seal in
      // Build Request
      let url = URL(string: "https://\(domain)/account/register")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      // Encode JSON
      do {
        let bodyData = try JSONEncoder().encode(account)
        request.httpBody = bodyData
        //let responseString = String(data: bodyData, encoding: .utf8)
      } catch {
        seal.reject(error)
      }
      // Send Data Task
      let session = URLSession.shared
      session.dataTask(with: request) { (data, response, error) in
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
            case 467:
                seal.reject(RemoteAPIError.passwordValidation)
            case 466:
                seal.reject(RemoteAPIError.dublicateError)
            case 500..<600:
                seal.reject(RemoteAPIError.serverError)
            default:
                seal.reject(RemoteAPIError.httpError)
            }
          return
        }
        if let data = data {
          do {
            let decoder = JSONDecoder()
            let payload = try decoder.decode(RecoverPasswordPayload.self, from: data)
            //TODO: - Need to fix this
            let remoteSession = RemoteUserSession(token: "")
            seal.fulfill(UserSession(error: payload.error, message: payload.message, remoteSession: remoteSession))
          } catch {
            seal.reject(error)
          }
        } else {
          seal.reject(RemoteAPIError.unknown)
        }
        }.resume()
    }
  }
    
    
    
    
}

struct SignInResponsePayload: Codable {
    //Should be used when after signing up server gives back information about user
    //let profile: UserProfile
    let error: String
    let message: String
    let token: String
}

struct RecoverPasswordPayload: Codable {
    let error: String
    let message: String
}

struct RecoverAccountPayload: Codable {
    let error: String
    let token: String
}


struct ConfirmAccountPayload: Codable {
    let error: String
    let confirmed: Bool
}
