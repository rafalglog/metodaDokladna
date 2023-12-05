//program na zajęcia: Metody Numeryczne projekt
//Proszę przygotować program do rozwiązywania układów równań liniowych dowolną metodą dokładną
//Wybrana metoda: metodą eliminacji Gaussa
//Rafał Głogowski
//numer albumu: 163707
//Grupa Dziekańska U2 Semestr 1

import Foundation

// Funkcja wczytująca macierz z pliku o podanej ścieżce
func loadMatrixFromFile(filePath: String) -> [[Double]]? {
    do {
        // Odczytaj zawartość pliku
        let contents = try String(contentsOfFile: filePath, encoding: .utf8)
        // Podziel zawartość na wiersze
        let rows = contents.components(separatedBy: .newlines)

        var matrix = [[Double]]()
        // Przetwórz każdy wiersz na tablicę Double-ów i dodaj go do macierzy
        for row in rows {
            let elements = row.components(separatedBy: " ")
                .compactMap { Double($0) }
            if !elements.isEmpty {
                matrix.append(elements)
            }
        }

        return matrix
    } catch {
        // Obsłuż błąd wczytywania pliku
        print("Błąd podczas wczytywania pliku: \(error)")
        return nil
    }
}

// Funkcja rozwiązująca układ równań liniowych metodą eliminacji Gaussa
func gaussElimination(_ augmentedMatrix: inout [[Double]]) -> [Double]? {
    let rowCount = augmentedMatrix.count
    let columnCount = augmentedMatrix[0].count - 1

    // Eliminacja współczynnika przed główną przekątną
    for i in 0..<rowCount {
        if augmentedMatrix[i][i] == 0 {
            return nil
        }

        let pivot = augmentedMatrix[i][i]

        // Normalizacja głównego wiersza dzieląc przez współczynnik na przekątnej
        for j in 0...columnCount {
            augmentedMatrix[i][j] /= pivot
        }

        // Eliminacja pozostałych współczynników w kolumnie
        for k in 0..<rowCount {
            if k != i {
                let factor = augmentedMatrix[k][i]
                for j in 0...columnCount {
                    augmentedMatrix[k][j] -= factor * augmentedMatrix[i][j]
                }
            }
        }
    }

    // Wyodrębnienie rozwiązania z ostatnich kolumn macierzy rozszerzonej
    var solution = [Double]()
    for i in 0..<rowCount {
        solution.append(augmentedMatrix[i][columnCount])
    }

    return solution
}

// Przykładowe użycie programu z załadowanymi danymi z pliku z separatorem przecinka
if let filePath = Bundle.main.path(forResource: "test", ofType: "txt") {
    if var systemOfEquations = loadMatrixFromFile(filePath: filePath) {
        if let solution = gaussElimination(&systemOfEquations) {
            print("Rozawiązanie: \(solution)")
        } else {
            print("Tą metodą nie uda się tego rozwiązać - główny element zawiera 0.")
        }
    } else {
        print("Błąd podczas wczytywania danych z pliku.")
    }
} else {
    print("Nie znaleziono pliku.")
}
