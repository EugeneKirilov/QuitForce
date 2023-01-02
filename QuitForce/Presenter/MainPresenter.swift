//
//  MainPresenter.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation

protocol AppViewProtocol: AnyObject {
    
}

protocol MainPresenterProtocol: AnyObject {
    init(view: AppViewProtocol)
    func setUpAppsData()
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: AppViewProtocol?
    var apps: [AppsListItem]?
    
    init(view: AppViewProtocol) {
        self.view = view
    }
    
    func setUpAppsData() {
        
    }
}
