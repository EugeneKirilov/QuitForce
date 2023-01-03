//
//  AppViewController.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 29.12.22.
//

import Cocoa

final class AppViewController: NSViewController {

    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var selectAllButton: NSButton!
    @IBOutlet var forceQuitButton: NSButton!
    @IBOutlet var tableView: NSTableView!
    
    private let cellIdentifier = NSUserInterfaceItemIdentifier("tableViewCell")
    var presenter: MainPresenterProtocol?
    
    init?(coder: NSCoder, presenter: MainPresenterProtocol) {
        self.presenter = presenter
        
        super.init(coder: coder)
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchField()
        setupAllButton()
        setupQuitButton()
        setupTableView()
        setupDelegates()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func setupSearchField() {
        searchField.placeholderString = "Type application name"
    }
    
    private func setupAllButton() {
        selectAllButton.title = "Select all"
    }
    
    private func setupQuitButton() {
        forceQuitButton.title = "Force quit"
        forceQuitButton.isEnabled = false
        forceQuitButton.bezelColor = .lightGray
    }
    
    private func setupTableView() {
        tableView.headerView = nil
    }
    
    private func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func selectAllButtonTapped(_ sender: NSButton) {
        print("selectAllButtonTapped")
    }
    
    @IBAction func forceQuitButtonTapped(_ sender: NSButton) {
        print("forceQuitButtonTapped")
    }
}

// MARK: - NSTableViewDataSource
extension AppViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let apps = presenter?.apps else { return 0 }
        return apps.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? TableViewCell else { return nil }
        guard let apps = presenter?.apps else { return nil }
        cell.cpuLabel.stringValue = apps[row].app.cpu + "% CPU"
        cell.nameLabel.stringValue = apps[row].app.name
        cell.iconImageView.image = apps[row].app.icon
        return cell
    }
}

// MARK: - NSTableViewDelegate
extension AppViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        false
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        60
    }
}

// MARK: - AppViewProtocol
extension AppViewController: AppViewProtocol {
    
}


