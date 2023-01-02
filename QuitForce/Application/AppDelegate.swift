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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let moduleBuilder = ModuleBuilder()
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: .main)
        let window  = storyboard.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        let appViewController = storyboard.instantiateController(identifier: "AppViewController", creator: { coder -> AppViewController? in
            AppViewController(coder: coder, presenter: moduleBuilder.createMain())
        })
        appViewController.presenter?.setUpAppsData()
        window.contentViewController = appViewController
        window.showWindow(self)
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.image = NSImage(named: "OnButton")
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

