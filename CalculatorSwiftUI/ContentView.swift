//
//  ContentView.swift
//  CalculatorSwiftUI
//
//  Created by Isaac Gongora on 17/01/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var calculatorBrain: CalculatorBrain = CalculatorBrain()
    
    var body: some View {
        GeometryReader { layout in
            let space: CGFloat = 5.0
            VStack(spacing: space) {
                Text(calculatorBrain.output)
                    .font(.largeTitle)
                    .frame(width: layout.size.width, height: 100, alignment: .trailing)
                    .foregroundColor(Color.white)
                    .background(Color.gray.opacity(0.5))
                
                Grid(horizontalSpacing: space, verticalSpacing: space) {
                    let keys: [[CalculatorBrain.Key]] = [
                        [.clear, .plusMinus, .percentage, .division],
                        [.seven, .eigth, .nine, .multiplication],
                        [.four, .five, .six, .substraction],
                        [.one, .two, .three, .addition]
                    ]
                    
                    // Creates regular grid keys
                    ForEach(keys, id: \.self) { keysRow in
                        GridRow {
                            ForEach(keysRow) { key in
                                Button {
                                    calculatorBrain.perform(for: key)
                                } label: {
                                    GeometryReader { button in
                                        Text(key.rawValue)
                                        .frame(width: button.size.width,
                                               height: button.size.height)
                                        .foregroundColor(calculatorBrain.foregroundColor(for: key))
                                    }
                                }
                                .font(.largeTitle)
                                .background(calculatorBrain.backgroudColor(for: key))
                            }
                        }
                    }
                    
                    // Bottom row created separately for custom layout
                    HStack(spacing: space) {
                        // Custom button of zero key
                        let zeroKey: CalculatorBrain.Key = .zero
                        GeometryReader { row in
                            Button {
                                calculatorBrain.perform(for: zeroKey)
                            } label: {
                                GeometryReader { button in
                                    Text(zeroKey.rawValue)
                                    .frame(width: button.size.width,
                                           height: button.size.height)
                                    .foregroundColor(Color.white)
                                }
                            }
                            .font(.largeTitle)
                            .background(zeroKey.color)
                        }
                        
                        let dotAndEqualKeys: [CalculatorBrain.Key] = [.dot, .equal]
                        GeometryReader { row in
                            HStack(spacing: space) {
                                ForEach(dotAndEqualKeys) { key in
                                    Button {
                                        calculatorBrain.perform(for: key)
                                    } label: {
                                        Text(key.rawValue)
                                            .frame(width: row.size.width * 0.5 - (space * 0.5),
                                                    height: row.size.height)
                                            .foregroundColor(Color.white)
                                    }
                                    .font(.largeTitle)
                                    .background(key.color)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background(Color.black)
    }
}
