//
//  AppViewController.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 29.12.22.
//

import Cocoa

class AppViewController: NSViewController {

    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var selectAllButton: NSButton!
    @IBOutlet var forceQuitButton: NSButton!
    @IBOutlet var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextField()
        setupAllButton()
        setupQuitButton()
        setupTableView()
        setupDelegates()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func setupTextField() {
        
    }
    
    private func setupAllButton() {
        
    }
    
    private func setupQuitButton() {
        
    }
    
    private func setupTableView() {
        tableView.headerView = nil
    }
    
    private func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func selectAllButtonTapped(_ sender: NSButton) {
    }
    
    @IBAction func forceQuitButtonTapped(_ sender: NSButton) {
    }
}

// MARK: - NSTableViewDataSource
extension AppViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        5
    }
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        <#code#>
//    }
}

// MARK: - NSTableViewDelegate
extension AppViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        false
    }
}


