//
//  MainPresenter.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation
import Cocoa

protocol AppViewProtocol: AnyObject {
    func isActivateQuitButton(flag: Bool)
    func isSelectAllButton(flag: Bool)
    func terminateSuccessful()
}

protocol MainPresenterProtocol: AnyObject {
    init(cpuLoader: CPULoaderProtocol)
    var view: AppViewProtocol? { get set }
    var apps: [AppsListItem]? { get }
    var quitingApps: [AppsListItem] { get set }
    func setUpAppsData()
    func appCheck(appListItem: inout AppsListItem?, presenter: inout MainPresenterProtocol?)
    func forceQuitApps()
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: AppViewProtocol?
    let cpuLoader: CPULoaderProtocol
    var apps: [AppsListItem]?
    var quitingApps = [AppsListItem]()
    
    init(cpuLoader: CPULoaderProtocol) {
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
                                                    cpu: cpuCount ?? "No data",
                                                    pid: String(app.processIdentifier))))
        }
    }
    
    func appCheck(appListItem: inout AppsListItem?, presenter: inout MainPresenterProtocol?) {
        if appListItem?.isSelected == false {
            appListItem?.setSelected(true)
            guard let app = appListItem else { return }
            self.quitingApps.append(app)
        } else {
            appListItem?.toggleSelection()
            guard let app = appListItem else { return }
            self.quitingApps.remove(at: self.quitingApps.firstIndex { $0.app == app.app } ?? 0 )
        }
        quitingApps.count == apps?.count ? view?.isSelectAllButton(flag: false) : view?.isSelectAllButton(flag: true)
        quitingApps.isEmpty ? view?.isActivateQuitButton(flag: false) : view?.isActivateQuitButton(flag: true)
    }
    
    private func isReadyForQuiting() -> Bool {
        quitingApps.isEmpty ? false : true
    }
    
    func forceQuitApps() {
        if isReadyForQuiting() {
            let openApps = NSWorkspace.shared.runningApplications
            for openApp in openApps {
                for appForQuit in quitingApps where String(openApp.processIdentifier) == appForQuit.app.pid {
                    openApp.terminate()
                }
            }
            for appForQuit in quitingApps {
                apps = apps?.filter { $0.app != appForQuit.app }
            }
            quitingApps = []
            view?.isActivateQuitButton(flag: false)
            view?.terminateSuccessful()
        }
    }
}
