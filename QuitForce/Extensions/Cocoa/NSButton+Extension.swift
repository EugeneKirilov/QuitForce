//
//  NSButton+Extension.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 13.01.23.
//

import Foundation
import Cocoa

extension NSButton {
    func isActivateQuitButton(flag: Bool) {
        if flag {
            self.isEnabled = true
            self.bezelColor = .systemBlue
        } else {
            self.isEnabled = false
            self.bezelColor = .lightGray
        }
    }
}
