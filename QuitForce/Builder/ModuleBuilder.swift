//
//  ModuleBuilder.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation
import Cocoa

protocol Builder {
    func createMain() -> MainPresenter
}

final class ModuleBuilder: Builder {
    func createMain() -> MainPresenter {
        let cpuLoader = CPULoader()
        let timerSetupper = TimerSetupper()
        let presenter = MainPresenter(cpuLoader: cpuLoader, timerSetupper: timerSetupper)
        return presenter
    }
}
