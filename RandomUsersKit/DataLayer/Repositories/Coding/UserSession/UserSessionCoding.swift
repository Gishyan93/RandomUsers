
//
//  Created by Tigran Gishyan on 12/1/20.
//

import Foundation

public protocol UserSessionCoding {
  
  func encode(userSession: UserSession) -> Data
  func decode(data: Data) -> UserSession
}
