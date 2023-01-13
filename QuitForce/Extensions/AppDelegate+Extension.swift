//
//  NSApplicationDelegate + Extension.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 11.01.23.
//

import Foundation
import Cocoa

extension AppDelegate {
    func setupMenu(statusBarItem: NSStatusItem) {
        let statusMenu = NSMenu()
        
        let terminateAllItem: NSMenuItem = {
            let item = NSMenuItem(
                title: StringConstants.terminateAllButtonText.rawValue,
                action: #selector(terminateAllApps),
                keyEquivalent: ""
            )
            
            item.tag = IntConstants.terminateAllButtonTag.rawValue
            item.target = self
            
            return item
        }()
        
        let openForceQuitItem: NSMenuItem = {
            let item = NSMenuItem(
                title: StringConstants.openForceQuitButtonText.rawValue,
                action: #selector(openForceQuitApp),
                keyEquivalent: ""
            )
            
            item.tag = IntConstants.openForceQuitButtonTag.rawValue
            item.target = self
            
            return item
        }()
        
        let quitApplicationItem: NSMenuItem = {
            let item = NSMenuItem(title: StringConstants.quitButtonText.rawValue, action: #selector(terminate),
                                  keyEquivalent: StringConstants.quitButtonKeyEquivalent.rawValue)
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
}
