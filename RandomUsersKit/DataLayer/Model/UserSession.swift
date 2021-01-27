
//
//  Created by Tigran Gishyan on 11/30/20.
//
import Foundation

public class UserSession: Codable {

  // MARK: - Properties
  
    public let error: String
    public let message: String
    public let remoteSession: RemoteUserSession

  // MARK: - Methods
    //public init(profile: UserProfile, remoteSession: RemoteUserSession) {
    public init(error: String, message: String, remoteSession: RemoteUserSession) {
        //self.profile = profile
        self.error = error
        self.message = message
        self.remoteSession = remoteSession
  }
}

extension UserSession: Equatable {
  
  public static func ==(lhs: UserSession, rhs: UserSession) -> Bool {
     return lhs.remoteSession == rhs.remoteSession
  }
}
