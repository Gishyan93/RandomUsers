
//
//  Created by Tigran Gishyan on 12/1/20.
//

import UIKit

class LaunchRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: LaunchViewModel
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        styleView()
        loadUserSession()
    }
    
    private func styleView() {
        backgroundColor = .appGray
    }
    
    private func loadUserSession() {
        viewModel.loadUserSession()
    }
    
}

