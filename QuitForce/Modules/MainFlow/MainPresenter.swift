//
//  MainPresenter.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation
import Cocoa

final class MainPresenter: MainPresenterProtocol {
    private let cpuLoader: CPULoaderProtocol
    private let timerSetupper: TimerSetupperProtocol
    
    private var temporaryApps = [AppsListItem]()
    private var appsBefore = [AppsListItem]()
    
    weak var view: AppViewProtocol?
    
    var cells = [AppCellPresenterProtocol]()
    var apps: [AppsListItem]?
    var quitingApps = [AppsListItem]()
    var appSearchString: String?
    
    init(cpuLoader: CPULoaderProtocol, timerSetupper: TimerSetupperProtocol) {
        self.cpuLoader = cpuLoader
        self.timerSetupper = timerSetupper
    }
    
    private func setupCells() {
        guard let apps = apps else { return }
        cells = apps.map { AppCellPresenter(app: $0) }

        if !cells.isEmpty {
            view?.updateSuccessful()
        }
    }
    
    private func checkAppsCheckMarks(appListItem: AppsListItem) {
        let appIndex = apps?.firstIndex { $0.app.name == appListItem.app.name }
        if let appIndex = appIndex {
            apps?[appIndex] = appListItem
        }
        
        let appIndexTmp = temporaryApps.firstIndex { $0.app.name == appListItem.app.name }
        if let appIndexTmp = appIndexTmp {
            temporaryApps[appIndexTmp] = appListItem
        }
        
        let appIndexBefore = appsBefore.firstIndex { $0.app.name == appListItem.app.name }
        if let appIndexBefore = appIndexBefore {
            appsBefore[appIndexBefore] = appListItem
        }
    }
    
    func setupAppsData() {
        let cpus = cpuLoader.getCPU()
        var tmpArray = [AppsListItem]()
        
        for app in NSWorkspace.shared.runningApplications where app.activationPolicy == .regular {
            let cpuCount = cpus.filter{ $0[String(app.processIdentifier)] != nil }.first?.values.joined()
            let appListItem = AppsListItem(app: App(name: app.localizedName ?? StringConstants.noData.rawValue,
                                                    icon: app.icon ?? NSImage(),
                                                    cpu: cpuCount ?? StringConstants.noData.rawValue,
                                                    pid: String(app.processIdentifier)))
            tmpArray.append(appListItem)

            let appIndex = apps?.firstIndex { $0.app.pid == appListItem.app.pid }
            
            if let appIndex = appIndex {
                apps?[appIndex].app.cpu = appListItem.app.cpu
            }
            
            if !(apps?.contains { $0.app.name == appListItem.app.name } ?? false) {
                if let apps = apps {
                    appsBefore = apps
                }
                apps?.append(appListItem)
            }
        }
        
        if tmpArray.count < apps?.count ?? 0 {
            apps = appsBefore
        }
        
        if apps == nil {
            apps = tmpArray
        }
        
        apps = apps?.sorted { $0.app.name.lowercased() < $1.app.name.lowercased() }
        temporaryApps = apps ?? [AppsListItem]()
        
        guard let apps = apps else { return }
        cells = apps.map { AppCellPresenter(app: $0) }

        if !cells.isEmpty {
            buttonsCheck()
            view?.updateSuccessful()
        }
    }
    
    func buttonsCheck() {
        quitingApps.count == apps?.count ? view?.isSelectAllButton(flag: false) : view?.isSelectAllButton(flag: true)
        quitingApps.isEmpty ? view?.updateQuitButton(flag: false) : view?.updateQuitButton(flag: true)
    }
    
    func appCheck(appListItem: AppsListItem) {
        if appListItem.isSelected == false {
            checkAppsCheckMarks(appListItem: appListItem)
            if let index = self.quitingApps.firstIndex(where: { $0.app == appListItem.app }) {
                self.quitingApps.remove(at: index)
            }
        } else {
            checkAppsCheckMarks(appListItem: appListItem)
            self.quitingApps.append(appListItem)
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
            
            cells.forEach { $0.view?.updateCheckbox(withValue: .off) }
            view?.updateQuitButton(flag: false)
            view?.updateSuccessful()
        }
    }
    
    func tapOnSelectAllButton() {
        guard let view = view else { return }
        if cells.count == cells.filter({ $0.app.isSelected }).count {
            view.selectAllButton.title = StringConstants.selectAllButtonText.rawValue
        
            for cell in cells {
                cell.setCheckboxSelectAll(value: .off)
                if let index = self.quitingApps.firstIndex(where: { $0.app == cell.app.app }) {
                    quitingApps.remove(at: index)
                }
                checkAppsCheckMarks(appListItem: cell.app)
            }
        } else {
            view.selectAllButton.title = StringConstants.deselectAllButtonText.rawValue
            
            for cell in cells {
                cell.setCheckboxSelectAll(value: .on)
                quitingApps.append(cell.app)
                checkAppsCheckMarks(appListItem: cell.app)
            }
        }
        buttonsCheck()
    }
    
    func searchApps() {
        guard let appSearchString = appSearchString else {
            apps = temporaryApps
            setupCells()
            buttonsCheck()
            return
        }
        
        var searchedAppsArray = [AppsListItem]()
        
        for appItem in temporaryApps where appItem.app.name.lowercased().hasPrefix(appSearchString.lowercased()) {
            searchedAppsArray.append(appItem)
            self.apps = searchedAppsArray
            setupCells()
            buttonsCheck()
        }
        self.view?.updateSuccessful()
    }
    
    func setupTimer() {
        timerSetupper.setupTimer { [weak self] in
            guard let self = self else { return }
            if self.apps?.count ?? 0 < self.temporaryApps.count {
                self.setupAppsData()
                self.searchApps()
            } else {
                self.setupAppsData()
            }
        }
    }
}
