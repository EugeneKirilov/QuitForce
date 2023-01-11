//
//  Constants.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 11.01.23.
//

import Foundation

enum StringConstants: String {
    case onButtonImage = "OnButton"
    case storyboardIdentifier = "Main"
    case windowIdentifier = "MainWindow"
    case appViewController = "AppViewController"
    case appCellIdentifier = "tableViewCell"
    case searchFieldPlaceholder = "Type application name"
    case selectAllButtonText = "Select all"
    case deselectAllButtonText = "Deselect all"
    case forceQuitButtonText = "Force quit"
    case terminateAllButtonText = "Terminate all"
    case openForceQuitButtonText = "Open ForceQuit"
    case quitButtonText = "Quit"
    case quitButtonKeyEquivalent = "q"
    case percentCPU = "% CPU"
    case noData = "No data"
    case loggerInfo = "INFO"
    case loggerWarn = "WARN ⚠️"
    case loggerError = "ALERT ❌"
    case minusCCommand = "-c"
    case terminalPath = "/bin/zsh"
    case psPidsCommand = "ps -eo pid"
    case psCPUCommand = "ps -eo %cpu"
    case emptySeparator = "\n"
    case commaSeparator = ","
    case pidHeader = "PID"
    case cpuHeader = "%CPU"
    case csvFileName = "CSVQuitForce.csv"
    case fileReadError = "File Read Error for file "
}

enum IntConstants: Int {
    case terminateAllButtonTag = 1
    case openForceQuitButtonTag = 2
}

enum CGFloatConstants: CGFloat {
    case cellHeight = 60
}
