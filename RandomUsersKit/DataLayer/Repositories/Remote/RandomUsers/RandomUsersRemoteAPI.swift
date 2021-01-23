
//
//  Created by Tigran Gishyan on 12/2/20.
//

import Foundation
import PromiseKit

public protocol RandomUsersRemoteAPI {
    
    func getRandomUsers() -> Promise<RandomUsers>
    func getMoreUsers(pageNumber: String) -> Promise<RandomUsers>
}

enum RemoteAPIError: Error {
    case unknown
    case createURL
    case passwordValidation
    case dublicateError
    case httpError
    case serverError
}
