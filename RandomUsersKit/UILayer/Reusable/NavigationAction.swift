
//
//  Created by Tigran Gishyan on 12/1/20.
//

import Foundation

public enum NavigationAction<ViewModelType>: Equatable where ViewModelType: Equatable {

    case present(view: ViewModelType)
    case presented(view: ViewModelType)
}


public enum NavigationActionWithKey<ViewModelType>: Equatable where ViewModelType: Equatable {

    case present(view: ViewModelType, key: String)
    case presented(view: ViewModelType, key: String)
}
