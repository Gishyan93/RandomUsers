//
//  Optional+.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/15/21.
//

extension Optional {

  var isEmpty: Bool {
    return self == nil
  }

  var exists: Bool {
    return self != nil
  }
}
