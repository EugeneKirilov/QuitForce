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
        let cpuLoader = CPULoader()
        let presenter = MainPresenter(view: view, cpuLoader: cpuLoader)
        view.presenter = presenter
    }
}
