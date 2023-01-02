//
//  TableViewCell.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Cocoa

class TableViewCell: NSTableCellView {

    @IBOutlet var checkbox: NSButton!
    @IBOutlet var iconImageView: NSImageView!
    @IBOutlet var nameLabel: NSTextField!
    @IBOutlet var cpuLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
