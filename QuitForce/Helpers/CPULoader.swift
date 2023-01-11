//
//  CPULoader.swift
//  QuitForce
//
//  Created by Zenya Kirilov on 2.01.23.
//

import Foundation

protocol CPULoaderProtocol {
    func getCPU() -> [[String: String]]
}

final class CPULoader: CPULoaderProtocol {
    private var pids = [String]()
    private var cpus = [String]()

    private var arrayForCSV: [Dictionary<String, String>] = Array()
    
    @discardableResult
    private func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = [StringConstants.minusCCommand.rawValue, command]
        task.executableURL = URL(fileURLWithPath: StringConstants.terminalPath.rawValue)
        task.standardInput = nil

        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? StringConstants.noData.rawValue
        
        return output
    }
    
    private func getPidsAndCPUs() {
        do {
            try pids = safeShell(StringConstants.psPidsCommand.rawValue).components(separatedBy: StringConstants.emptySeparator.rawValue).map { $0.trimmingCharacters(in: .whitespaces) }
            try cpus = safeShell(StringConstants.psCPUCommand.rawValue).components(separatedBy: StringConstants.emptySeparator.rawValue).map { $0.trimmingCharacters(in: .whitespaces) }
        } catch let error {
            Log.error(error.localizedDescription)
        }
    }
    
    private func makeArrayForCSV() {
        arrayForCSV = []
        
        getPidsAndCPUs()
        
        for (index, currentPid) in pids.enumerated() {
            var dct = Dictionary<String, String>()
            dct.updateValue(cpus[index], forKey: currentPid)
            arrayForCSV.append(dct)
        }
        
        arrayForCSV.removeFirst()
        arrayForCSV.removeLast()
    }

    private func createNewCSVFile(stringCSV: String) {
        do {
            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent(StringConstants.csvFileName.rawValue)
            try stringCSV.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch let error {
            Log.error(error.localizedDescription)
        }
    }
    
    private func createCSV(from recArray:[Dictionary<String, String>]) {
        var csvString = "\(StringConstants.pidHeader.rawValue),\(StringConstants.cpuHeader)\(StringConstants.emptySeparator.rawValue)"
        for dct in recArray {
            csvString = csvString.appending("\((dct.keys).joined()) ,\((dct.values).joined())\(StringConstants.emptySeparator.rawValue)")
        }
        
        createNewCSVFile(stringCSV: csvString)
    }

    private func readDataFromCSV(fileName: String) -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else {
            return nil
        }
        
        let fileURL = directory.appendingPathComponent(fileName)
        
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            return contents
        } catch {
            Log.error(StringConstants.fileReadError.rawValue + fileName)
            return nil
        }
    }

    func getCPU() -> [[String: String]] {
        makeArrayForCSV()
        
        createCSV(from: arrayForCSV)
        
        let data = readDataFromCSV(fileName: StringConstants.csvFileName.rawValue)
        
        var result: [[String: String]] = []
        let rows = (data ?? StringConstants.noData.rawValue).components(separatedBy: StringConstants.emptySeparator.rawValue)
        
        for row in rows {
            let newRow = row.replacingOccurrences(of: " ", with: "")
            let columns = newRow.components(separatedBy: CharacterSet(charactersIn: StringConstants.commaSeparator.rawValue))
            var dictionary = Dictionary<String, String>()
            dictionary.updateValue(columns.last ?? StringConstants.noData.rawValue, forKey: columns[0])
            result.append(dictionary)
        }
        
        result.removeLast()
        
        return result
    }
}
