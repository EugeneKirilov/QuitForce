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
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    private func makeArrayForCSV() {
        arrayForCSV = []
        do {
            try pids = safeShell("ps -eo pid").components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces)}
        } catch let error {
            Log.error(error.localizedDescription)
        }

        do {
            try cpus = safeShell("ps -eo %cpu").components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces)}
        }
        catch let error {
            Log.error(error.localizedDescription)
        }
        
        var index = 0
        for i in pids {
            var dct = Dictionary<String, String>()
            dct.updateValue(cpus[index], forKey: i)
            arrayForCSV.append(dct)
            index += 1
        }
        
        arrayForCSV.removeFirst()
        arrayForCSV.removeLast()
    }

    private func createCSV(from recArray:[Dictionary<String, String>]) {
        var csvString = "\("PID"),\("%CPU")\n"
        for dct in recArray {
            csvString = csvString
                .appending("\((dct.keys).joined()) ,\((dct.values).joined())\n")
        }
        
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("CSVQuitForce.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            Log.error("Error creating file")
        }
    }

    private func readDataFromCSV(fileName: String) -> String? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else {
            return nil
        }
        let fileURL = dir.appendingPathComponent(fileName)
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            return contents
        } catch {
            Log.error("File Read Error for file \(fileName)")
            return nil
        }
    }

    func getCPU() -> [[String: String]] {
        makeArrayForCSV()
        createCSV(from: arrayForCSV)
        let data = readDataFromCSV(fileName: "CSVQuitForce.csv")
        
        var result: [[String: String]] = []
        let rows = data!.components(separatedBy: "\n")
        for row in rows {
            let newRow = row.replacingOccurrences(of: " ", with: "")
            let columns = newRow.components(separatedBy: CharacterSet(charactersIn: ","))
            var dictionary = Dictionary<String, String>()
            dictionary.updateValue(columns.last ?? "no data",
                                   forKey: columns[0])
            result.append(dictionary)
        }
        result.removeLast()
        return result
    }
}
