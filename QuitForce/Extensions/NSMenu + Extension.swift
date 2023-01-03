//
//  NSMenu + Extension.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 3.01.23.
//

import Foundation
import AppKit

extension NSMenu {
    func addSeparator() -> Void {
        addItem(.separator())
    }
    
    func addItems(_ items: NSMenuItem...) {
        for item in items {
            addItem(item)
        }
    }
}
