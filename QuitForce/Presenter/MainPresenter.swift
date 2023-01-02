//
//  MainPresenter.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation
import Cocoa

protocol AppViewProtocol: AnyObject {
    
}

protocol MainPresenterProtocol: AnyObject {
    init(view: AppViewProtocol, cpuLoader: CPULoaderProtocol)
    var apps: [AppsListItem]? { get }
    func setUpAppsData()
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: AppViewProtocol?
    let cpuLoader: CPULoaderProtocol
    var apps: [AppsListItem]?
    
    init(view: AppViewProtocol, cpuLoader: CPULoaderProtocol) {
        self.view = view
        self.cpuLoader = cpuLoader
    }
    
    func setUpAppsData() {
        self.apps = []
        let openApps = NSWorkspace.shared.runningApplications
        let cpus = cpuLoader.getCPU()
        for app in openApps where app.activationPolicy == .regular {
            let cpuCount = cpus.filter{ $0[String(app.processIdentifier)] != nil }.first?.values.joined()
            self.apps?.append(AppsListItem(app: App(name: app.localizedName ?? "No data",
                                                    icon: app.icon ?? NSImage(),
                                                    cpu: cpuCount ?? "No data")))
        }
    }
}
