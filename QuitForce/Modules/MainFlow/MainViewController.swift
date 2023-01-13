//
//  MainViewController.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 29.12.22.
//

import Cocoa

final class MainViewController: NSViewController {

    // private добавить
    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var selectAllButton: NSButton!
    @IBOutlet var forceQuitButton: NSButton!
    @IBOutlet var tableView: NSTableView!
    
    private let cellIdentifier = NSUserInterfaceItemIdentifier(StringConstants.appCellIdentifier.rawValue)
    
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
    
    private func setupSearchField() {
        searchField.placeholderString = StringConstants.searchFieldPlaceholder.rawValue
    }
    
    private func setupAllButton() {
        selectAllButton.title = StringConstants.selectAllButtonText.rawValue
    }
    
    private func setupQuitButton() {
        forceQuitButton.title = StringConstants.forceQuitButtonText.rawValue
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
        presenter?.tapOnSelectAllButton()
    }
    
    @IBAction func forceQuitButtonTapped(_ sender: NSButton) {
        presenter?.forceQuitApps()
    }
}

// MARK: - NSTableViewDataSource
extension MainViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let apps = presenter?.apps else { return 0 }
        return apps.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? AppTableCellView,
              let apps = presenter?.apps else { return nil }
        
        cell.presenter = presenter?.cells[row]
        cell.presenter?.view = cell
        cell.presenter?.delegate = self.presenter

        if cell.presenter?.app.isSelected == true {
            cell.updateCheckbox(withValue: .on)
        }

        cell.updateElements(cpuLabel: apps[row].app.cpu + StringConstants.percentCPU.rawValue,
                            nameLabel: apps[row].app.name,
                            icon: apps[row].app.icon)
        
        return cell
    }
}

// MARK: - NSTableViewDelegate
extension MainViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        false
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        CGFloatConstants.cellHeight.rawValue
    }
}

// MARK: - AppViewProtocol
extension MainViewController: AppViewProtocol {
    func updateQuitButton(flag: Bool) {
        forceQuitButton.isActivateQuitButton(flag: flag)
    }
    
    func isSelectAllButton(flag: Bool) {
        selectAllButton.title = flag ? StringConstants.selectAllButtonText.rawValue : StringConstants.deselectAllButtonText.rawValue
    }
    
    func updateSuccessful() {
        tableView.reloadData()
    }
}


