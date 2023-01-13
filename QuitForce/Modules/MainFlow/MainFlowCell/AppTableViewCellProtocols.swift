import Foundation
import Cocoa

protocol AppCellPresenterProtocol: AnyObject {
    var app: AppsListItem { get set }
    var view: AppCellViewProtocol? { get set }
    var delegate: MainPresenterProtocol? { get set }
    
    func setCheckboxSelectAll(value: NSControl.StateValue)
    func setCheckbox(value: NSControl.StateValue)
}
