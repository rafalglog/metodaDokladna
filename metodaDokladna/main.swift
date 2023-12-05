// praca zaliczeniowa na

import Foundation

func loadMatrixFromFile(filePath: String) -> [[Double]]? {
    do {
        let contents = try String(contentsOfFile: filePath, encoding: .utf8)
        let rows = contents.components(separatedBy: .newlines)

        var matrix = [[Double]]()
        for row in rows {
            let elements = row.components(separatedBy: " ")
                .compactMap { Double($0) }
            if !elements.isEmpty {
                matrix.append(elements)
            }
        }

        return matrix
    } catch {
        print("Error loading file: \(error)")
        return nil
    }
}

func gaussElimination(_ augmentedMatrix: inout [[Double]]) -> [Double]? {
    let rowCount = augmentedMatrix.count
    let columnCount = augmentedMatrix[0].count - 1

    for i in 0..<rowCount {
        if augmentedMatrix[i][i] == 0 {
            return nil
        }

        let pivot = augmentedMatrix[i][i]

        for j in 0...columnCount {
            augmentedMatrix[i][j] /= pivot
        }

        for k in 0..<rowCount {
            if k != i {
                let factor = augmentedMatrix[k][i]
                for j in 0...columnCount {
                    augmentedMatrix[k][j] -= factor * augmentedMatrix[i][j]
                }
            }
        }
    }

    var solution = [Double]()
    for i in 0..<rowCount {
        solution.append(augmentedMatrix[i][columnCount])
    }

    return solution
}

// Example usage with loading data from a file with comma separators
if let filePath = Bundle.main.path(forResource: "test", ofType: "txt") {
    if var systemOfEquations = loadMatrixFromFile(filePath: filePath) {
        if let solution = gaussElimination(&systemOfEquations) {
            print("Rozawiązanie: \(solution)")
        } else {
            print("Tą metodą nie uda się tego rozwiązać - główny element zawiera 0.")
        }
    } else {
        print("Failed to load data from the file.")
    }
} else {
    print("File not found.")
}
