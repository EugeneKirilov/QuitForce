import Foundation
import Cocoa

protocol AppCellViewProtocol: AnyObject {
    func updateElements(cpuLabel: String, nameLabel: String, icon: NSImage)
    func updateCheckbox(withValue: NSControl.StateValue)
}
