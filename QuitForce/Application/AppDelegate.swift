//
//  AppDelegate.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 29.12.22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private func setupMenu() {
        let statusMenu = NSMenu()
        
        let terminateAllItem: NSMenuItem = {
            let item = NSMenuItem(
                title: "Terminate all",
                action: #selector(terminateAllApps),
                keyEquivalent: ""
            )
            
            item.tag = 1
            item.target = self
            
            return item
        }()
        
        let openForceQuitItem: NSMenuItem = {
            let item = NSMenuItem(
                title: "Open ForceQuit",
                action: #selector(openForceQuitApp),
                keyEquivalent: ""
            )
            
            item.tag = 2
            item.target = self
            
            return item
        }()
        
        let quitApplicationItem: NSMenuItem = {
            let item = NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q")
            item.target = self
            
            return item
        }()
        
        statusMenu.addItems(
            terminateAllItem,
            .separator(),
            openForceQuitItem,
            .separator(),
            quitApplicationItem
        )
        
        statusBarItem.menu = statusMenu
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let moduleBuilder = ModuleBuilder()
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: .main)
        let window  = storyboard.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        let appViewController = storyboard.instantiateController(identifier: "AppViewController", creator: { coder -> AppViewController? in
            AppViewController(coder: coder, presenter: moduleBuilder.createMain())
        })
        appViewController.presenter?.setUpAppsData()
        appViewController.presenter?.view = appViewController
        window.contentViewController = appViewController
        window.showWindow(self)
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.image = NSImage(named: "OnButton")
        setupMenu()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @objc
    func terminateAllApps(_ sender: NSMenuItem) {
        let openApps = NSWorkspace.shared.runningApplications
        for openApp in openApps {
            openApp.terminate()
        }
    }
    
    @objc
    func openForceQuitApp(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc
    func terminate(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }
}
