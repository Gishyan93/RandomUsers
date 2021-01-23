
//
//  Created by Tigran Gishyan on 12/1/20.
//

import Foundation

public class UserSessionPropertyListCoder: UserSessionCoding {

  // MARK: - Methods
  public init() {}

  public func encode(userSession: UserSession) -> Data {
    return try! PropertyListEncoder().encode(userSession)
  }

  public func decode(data: Data) -> UserSession {
    return try! PropertyListDecoder().decode(UserSession.self, from: data)
  }
}
