import Foundation

protocol MainPresenterProtocol: AnyObject {
    init(cpuLoader: CPULoaderProtocol, timerSetupper: TimerSetupperProtocol)
    
    var view: AppViewProtocol? { get set }
    var cells: [AppCellPresenterProtocol] { get set }
    var apps: [AppsListItem]? { get set }
    var quitingApps: [AppsListItem] { get set }
    var appSearchString: String? { get set }
    
    func setupAppsData()
    func buttonsCheck()
    func appCheck(appListItem: AppsListItem)
    func forceQuitApps()
    func tapOnSelectAllButton()
    func searchApps()
    func setupTimer()
}
