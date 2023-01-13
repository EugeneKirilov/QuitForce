//
//  AppCellPresenter.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 12.01.23.
//

import Foundation
import Cocoa

class AppCellPresenter: AppCellPresenterProtocol {
    var app: AppsListItem
    var delegate: MainPresenterProtocol?
    weak var view: AppCellViewProtocol?
    
    init(app: AppsListItem) {
        self.app = app
    }
    
    func setCheckboxSelectAll(value: NSControl.StateValue) {
        value == .on ? app.setSelected(true) : app.toggleSelection()
        view?.updateCheckbox(withValue: value)
    }
    
    func setCheckbox(value: NSControl.StateValue) {
        setCheckboxSelectAll(value: value)
        delegate?.appCheck(appListItem: app)
    }
}
