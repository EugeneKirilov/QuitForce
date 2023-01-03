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
    init(cpuLoader: CPULoaderProtocol)
    var view: AppViewProtocol? { get set }
    var apps: [AppsListItem]? { get }
    var quitingApps: [AppsListItem] { get set }
    var appSearchString: String? { get set }
    func setUpAppsData()
    func appCheck(appListItem: inout AppsListItem?,
                  presenter: inout MainPresenterProtocol?)
    func forceQuitApps()
    func tapOnSelectAllButton()
    func searchApps()
    func setupTimer()
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: AppViewProtocol?
    let cpuLoader: CPULoaderProtocol
    var apps: [AppsListItem]?
    var quitingApps = [AppsListItem]()
    var appSearchString: String?
    
    private var temporaryApps = [AppsListItem]()
    
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
        temporaryApps = apps ?? [AppsListItem]()
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
                temporaryApps = apps ?? [AppsListItem]()
            }
            quitingApps = []
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
    
    func setupTimer() {
        DispatchQueue.global(qos: .background).async {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.setUpAppsData()
                    self?.view?.updateSuccessful()
                }
            }
            RunLoop.current.run()
        }
    }
}
