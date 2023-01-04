//
//  TimerSetupper.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 4.01.23.
//

import Foundation

protocol TimerSetupperProtocol {
    func setupTimer(handler: @escaping () -> Void)
}

class TimerSetupper: TimerSetupperProtocol {
    func setupTimer(handler: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                DispatchQueue.main.async {
                    handler()
                }
            }
            RunLoop.current.run()
        }
    }
}
