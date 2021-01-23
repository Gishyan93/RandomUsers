
//
//  Created by Tigran Gishyan on 11/30/20.
//

import Foundation

public struct RemoteUserSession: Codable {

  // MARK: - Properties
  let token: AuthToken

  // MARK: - Methods
  public init(token: AuthToken) {
    self.token = token
  }
}

extension RemoteUserSession: Equatable {
  
  public static func ==(lhs: RemoteUserSession, rhs: RemoteUserSession) -> Bool {
    return lhs.token == rhs.token
  }
}

