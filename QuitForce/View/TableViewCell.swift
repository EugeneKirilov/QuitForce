//
//  TableViewCell.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Cocoa

final class TableViewCell: NSTableCellView {

    @IBOutlet var checkbox: NSButton!
    @IBOutlet var iconImageView: NSImageView!
    @IBOutlet var nameLabel: NSTextField!
    @IBOutlet var cpuLabel: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    private func setupViews() {
        
    }
    
}
