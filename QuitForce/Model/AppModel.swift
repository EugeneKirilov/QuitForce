//
//  AppModel.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 29.12.22.
//

import Cocoa

public struct App: Equatable {
    var name: String
    var icon: NSImage
    var cpu: String
    var pid: String
}

public struct AppsListItem: Equatable {
    var app: App
    var isSelected: Bool = false
    
    mutating func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    mutating func toggleSelection() {
        self.isSelected.toggle()
    }
}
