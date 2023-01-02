//
//  ModuleBuilder.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation
import Cocoa

protocol Builder {
    static func createMain() -> NSViewController
}

final class ModuleBuilder: Builder {
    static func createMain() -> NSViewController {
        let view = AppViewController()
        let presenter = MainPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
