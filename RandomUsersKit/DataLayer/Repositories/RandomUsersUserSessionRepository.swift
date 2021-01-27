
//
//  Created by Tigran Gishyan on 1/21/21.
//

import Foundation
import PromiseKit

public class RandomUsersUserSessionRepository: UserSessionRepository {
    
    // MARK: - Properties
    let dataStore: UserSessionDataStore
    
    // MARK: - Methods
    
    public init(dataStore: UserSessionDataStore) {
        self.dataStore = dataStore
    }
    
    public func readUserSession() -> Promise<UserSession?> {
        return dataStore.readUserSession()
    }
}

