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
    var cells = [TableViewCell]()
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
        presenter?.setupTimer()
    }

    override var representedObject: Any? {
        didSet {}
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
    
    @IBAction func searchPrograms(_ sender: NSSearchField) {
        presenter?.appSearchString = searchField.stringValue
        presenter?.searchApps()
    }
    
    @IBAction func selectAllButtonTapped(_ sender: NSButton) {
        presenter?.tapOnSelectAllButton(cells: &cells)
    }
    
    @IBAction func forceQuitButtonTapped(_ sender: NSButton) {
        presenter?.forceQuitApps()
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
        cells.append(cell)
        guard let apps = presenter?.apps else { return nil }
        cell.checkbox.state = .off
        let flag = presenter?.selectionCheck(appListItem: apps[row])
        
        if flag == true {
            cell.checkbox.state = .on
        }

        cell.presenter = self.presenter
        cell.app = apps[row]
        cell.cpuLabel.stringValue = apps[row].app.cpu + "% CPU"
        cell.nameLabel.stringValue = apps[row].app.name
        cell.iconImageView.image = apps[row].app.icon
        print(cells.count)
        return cell as NSView
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
    
    func isActivateQuitButton(flag: Bool) {
        if flag {
            forceQuitButton.isEnabled = true
            forceQuitButton.bezelColor = .systemBlue
        } else {
            forceQuitButton.isEnabled = false
            forceQuitButton.bezelColor = .lightGray
        }
    }
    
    func isSelectAllButton(flag: Bool) {
        if flag {
            selectAllButton.title = "Select all"
        } else {
            selectAllButton.title = "Deselect all"
        }
    }
    
    func updateSuccessful() {
//        cells = []
        tableView.reloadData()
    }
}


