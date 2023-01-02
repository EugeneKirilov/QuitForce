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
        moduleBuilder.createMain()
        
        guard let statusButton = statusBarItem.button else { return }
        statusButton.image = NSImage(named: "OnButton")
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

