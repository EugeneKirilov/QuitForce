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
    
    var presenter: MainPresenterProtocol?
    var app: AppsListItem?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    @IBAction func checkboxTapped(_ sender: NSButton) {
        presenter?.appCheck(appListItem: &app, presenter: &presenter)
    }
    
}
