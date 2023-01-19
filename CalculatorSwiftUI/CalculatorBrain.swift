//
//  CalculatorBrain.swift
//  CalculatorSwiftUI
//
//  Created by Isaac Gongora on 17/01/23.
//

import Foundation
import SwiftUI

class CalculatorBrain: ObservableObject {
    @Published var output: String = "0"
    @Published var currentFunctionKeyPressed: Key?
    var accumulator: Float = .zero
    var shouldStartFromZero: Bool = true
    var lastFunctionPerformed: BinaryFunction?
    
    func perform(for key: Key) {
        guard let value = Float(output) else { return }
        
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        
        if key.isNumber {
            if shouldStartFromZero {
                output = "\(key.rawValue)"
                shouldStartFromZero = false
            }
            else {
                output += "\(key.rawValue)"
            }
        }
        else {
            switch key {
            case .addition, .substraction, .multiplication, .division:
                let functionsDic: [Key: BinaryFunction] = [
                    .addition: { x, y in x + y },
                    .substraction: { x, y in x - y },
                    .multiplication: { x, y in x * y },
                    .division: { x, y in x / y }
                ]
                
                if let lastFunctionPerformed = lastFunctionPerformed {
                    let result: Float = lastFunctionPerformed(accumulator, value)
                    output = numberFormatter.string(from: NSNumber(value: result)) ?? ""
                    accumulator = result
                }
                else {
                    accumulator = value
                }
                
                lastFunctionPerformed = functionsDic[key]
                currentFunctionKeyPressed = key
                shouldStartFromZero = true
            case .clear:
                output = "0"
                shouldStartFromZero = true
                currentFunctionKeyPressed = nil
            case .dot:
                if shouldStartFromZero {
                    output = "0."
                    shouldStartFromZero = false
                }
                else {
                    output += "."
                }
            case .equal:
                output = numberFormatter.string(from: NSNumber(value: lastFunctionPerformed?(accumulator, value) ?? 0)) ?? ""
                currentFunctionKeyPressed = nil
                lastFunctionPerformed = nil
                shouldStartFromZero = true
                accumulator = .zero
            case .plusMinus:
                output = numberFormatter.string(from: NSNumber(value: value * -1)) ?? ""
            case .percentage:
                output = numberFormatter.string(from: NSNumber(value: value * 0.01)) ?? ""
            default:
                break
            }
        }
    }
    
    func foregroundColor(for key: Key) -> Color {
        return currentFunctionKeyPressed == key ? key.color : .white
    }
    
    func backgroudColor(for key: Key) -> Color {
        return currentFunctionKeyPressed == key ? .white : key.color
    }
    
    // Supporting types
    typealias BinaryFunction = (Float, Float) -> Float
    
    enum Key: String, Identifiable {
        case clear = "A/C"
        case plusMinus = "+/-"
        case percentage = "%"
        case addition = "+"
        case substraction = "-"
        case multiplication = "x"
        case division = "/"
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eigth = "8"
        case nine = "9"
        case dot = "."
        case equal = "="
        
        var id: String {
            return rawValue
        }
        var isNumber: Bool {
            switch self {
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eigth, .nine:
                return true
            default:
                return false
            }
        }
        var color: Color {
            switch self {
            case .dot, .zero, .one, .two, .three, .four, .five, .six, .seven, .eigth, .nine:
                return .gray
            case .division, .multiplication, .substraction, .addition, .equal:
                return .orange
            default:
                return .gray.opacity(0.5)
            }
        }
    }
}
