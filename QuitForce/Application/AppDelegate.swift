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
    
    private func setupStatusButton() {
        guard let statusButton = statusBarItem.button else { return }
        statusButton.image = NSImage(named: StringConstants.onButtonImage.rawValue)
    }
    
    private func setupInitialVC() {
        let moduleBuilder = ModuleBuilder()
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name(StringConstants.storyboardIdentifier.rawValue), bundle: .main)
        let window = storyboard.instantiateController(withIdentifier: StringConstants.windowIdentifier.rawValue) as! NSWindowController
        let appViewController = storyboard.instantiateController(identifier: StringConstants.appViewController.rawValue,
                                                                 creator: { coder -> AppViewController? in
            AppViewController(coder: coder, presenter: moduleBuilder.createMain())
        })
        
        appViewController.presenter?.setUpAppsData()
        appViewController.presenter?.view = appViewController
    
        window.contentViewController = appViewController
        window.showWindow(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupInitialVC()
        setupStatusButton()
        setupMenu(statusBarItem: statusBarItem)
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
