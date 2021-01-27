//
//  String+.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/15/21.
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
