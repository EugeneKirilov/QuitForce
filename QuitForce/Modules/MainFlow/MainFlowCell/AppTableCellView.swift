//
//  AppTableCellView.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Cocoa

final class AppTableCellView: NSTableCellView {

    @IBOutlet private var checkbox: NSButton!
    @IBOutlet private var iconImageView: NSImageView!
    @IBOutlet private var nameLabel: NSTextField!
    @IBOutlet private var cpuLabel: NSTextField!
    
    var presenter: AppCellPresenterProtocol?
    
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
        presenter?.setCheckbox(value: sender.state)
    }
    
}

extension AppTableCellView: AppCellViewProtocol {
    func updateElements(cpuLabel: String, nameLabel: String, icon: NSImage) {
        self.cpuLabel.stringValue = cpuLabel
        self.nameLabel.stringValue = nameLabel
        iconImageView.image = icon
    }
    
    func updateCheckbox(withValue: NSControl.StateValue) {
        checkbox.state = withValue
    }
}
