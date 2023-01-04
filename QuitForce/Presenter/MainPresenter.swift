//
//  MainPresenter.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation
import Cocoa

protocol AppViewProtocol: AnyObject {
    var cells: [TableViewCell] { get set }
    var selectAllButton: NSButton! { get set }
    func isActivateQuitButton(flag: Bool)
    func isSelectAllButton(flag: Bool)
    func updateSuccessful()
}

protocol MainPresenterProtocol: AnyObject {
    init(cpuLoader: CPULoaderProtocol, timerSetupper: TimerSetupperProtocol)
    var view: AppViewProtocol? { get set }
    var apps: [AppsListItem]? { get set }
    var quitingApps: [AppsListItem] { get set }
    var appSearchString: String? { get set }
    func setUpAppsData()
    func appCheck(appListItem: inout AppsListItem?,
                  presenter: inout MainPresenterProtocol?)
    func forceQuitApps()
    func tapOnSelectAllButton()
    func searchApps()
    func setupTimer()
    func selectionCheck(appListItem: AppsListItem) -> Bool
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: AppViewProtocol?
    let cpuLoader: CPULoaderProtocol
    let timerSetupper: TimerSetupperProtocol
    var apps: [AppsListItem]?
    var quitingApps = [AppsListItem]()
    var appSearchString: String?
    
    private var temporaryApps = [AppsListItem]()
    
    init(cpuLoader: CPULoaderProtocol, timerSetupper: TimerSetupperProtocol) {
        self.cpuLoader = cpuLoader
        self.timerSetupper = timerSetupper
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
        apps = apps?.sorted { $0.app.name.lowercased() < $1.app.name.lowercased() }
        temporaryApps = apps ?? [AppsListItem]()
    }
    
    private func buttonsCheck() {
        quitingApps.count == apps?.count ? view?.isSelectAllButton(flag: false) : view?.isSelectAllButton(flag: true)
        quitingApps.isEmpty ? view?.isActivateQuitButton(flag: false) : view?.isActivateQuitButton(flag: true)
    }
    
    func appCheck(appListItem: inout AppsListItem?, presenter: inout MainPresenterProtocol?) {
        if appListItem?.isSelected == false {
            appListItem?.setSelected(true)
            guard let app = appListItem else { return }
            let appIndex = apps?.firstIndex { $0.app.name == app.app.name }
            if let appIndex = appIndex {
                apps?[appIndex] = app
            }
            self.quitingApps.append(app)
        } else {
            appListItem?.toggleSelection()
            guard let app = appListItem else { return }
            let appIndex = apps?.firstIndex { $0.app.name == app.app.name }
            if let appIndex = appIndex {
                apps?[appIndex] = app
            }
            self.quitingApps.remove(at: self.quitingApps.firstIndex { $0.app == app.app } ?? 0 )
        }
        buttonsCheck()
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
                temporaryApps = apps ?? [AppsListItem]()
            }
            quitingApps = []
            view?.cells.forEach { $0.checkbox.state = .off }
            view?.isActivateQuitButton(flag: false)
            view?.updateSuccessful()
        }
    }
    
    func tapOnSelectAllButton() {
        guard let view = view else  { return }
        if view.cells.count == view.cells.filter({ $0.checkbox.state == .on }).count {
            view.selectAllButton.title = "Select all"
        
            for cell in view.cells where cell.checkbox.state == .on {
                cell.checkbox.state = .off
                appCheck(appListItem: &cell.app, presenter: &cell.presenter)
            }
        } else {
            view.selectAllButton.title = "Deselect all"
            for cell in view.cells where cell.checkbox.state == .off {
                cell.checkbox.state = .on
                appCheck(appListItem: &cell.app, presenter: &cell.presenter)
            }
        }
    }
    
    func searchApps() {
        guard let appSearchString = appSearchString else {
            apps = temporaryApps
            return
        }
        
        var searchedAppsArray = [AppsListItem]()
        for appItem in temporaryApps where appItem.app.name.lowercased().hasPrefix(appSearchString.lowercased()) {
            searchedAppsArray.append(appItem)
            self.apps = searchedAppsArray
        }
        self.view?.updateSuccessful()
    }
    
    private func updateAppsData() {
        let openApps = NSWorkspace.shared.runningApplications
        let cpus = cpuLoader.getCPU()
        var tmpArray = [AppsListItem]()
        for app in openApps where app.activationPolicy == .regular {
            let cpuCount = cpus.filter{ $0[String(app.processIdentifier)] != nil }.first?.values.joined()
            let appListItem = AppsListItem(app: App(name: app.localizedName ?? "No data",
                                                    icon: app.icon ?? NSImage(),
                                                    cpu: cpuCount ?? "No data",
                                                    pid: String(app.processIdentifier)))
            tmpArray.append(appListItem)
            let appIndex = apps?.firstIndex { $0.app.name == appListItem.app.name }
            if let appIndex = appIndex {
                apps?[appIndex].app = appListItem.app
            }
            if !(apps?.contains { $0.app.name == appListItem.app.name } ?? false) {
                apps?.append(appListItem)
            }
            if tmpArray.count < apps?.count ?? 0 {
                
            }
        }
        apps = apps?.sorted { $0.app.name.lowercased() < $1.app.name.lowercased() }
        temporaryApps = apps ?? [AppsListItem]()
    }
    
    func selectionCheck(appListItem: AppsListItem) -> Bool {
        if appListItem.isSelected {
            return true
        } else {
            return false
        }
    }
    
    func setupTimer() {
        timerSetupper.setupTimer { [weak self] in
            guard let self = self else { return }
            if self.apps?.count ?? 0 < self.temporaryApps.count {
                self.updateAppsData()
                self.searchApps()
            } else {
                self.updateAppsData()
                self.view?.updateSuccessful()
            }
        }
    }
}
