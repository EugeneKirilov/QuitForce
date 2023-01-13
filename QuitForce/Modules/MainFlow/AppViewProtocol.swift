import Foundation
import Cocoa

protocol AppViewProtocol: AnyObject {
    var selectAllButton: NSButton! { get set }
    
    func updateQuitButton(flag: Bool)
    func isSelectAllButton(flag: Bool)
    func updateSuccessful()
}
