//
//  RandomUsersLocationRepository.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 12/2/20.
//

import Foundation
import PromiseKit

public class RandomUsersLocationRepository {

  // MARK: - Properties
  let remoteAPI: RandomUsersRemoteAPI

  // MARK: - Methods
  public init(remoteAPI: RandomUsersRemoteAPI) {
    self.remoteAPI = remoteAPI
  }

}

