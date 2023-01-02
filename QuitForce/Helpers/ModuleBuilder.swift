//
//  ModuleBuilder.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation
import Cocoa

protocol Builder {
    func createMain()
}

final class ModuleBuilder: Builder {
    func createMain() {
        let view = AppViewController()
        let presenter = MainPresenter(view: view)
        view.presenter = presenter
    }
}
