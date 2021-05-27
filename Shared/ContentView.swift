//
//  ContentView.swift
//  Shared
//
//  Created by Nicolas Castillo on 21-05-21.
//

import SwiftUI

enum CalcButton: String {
    
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case equal = "="
    case clear = "C"
    case answer = "Ans"
    case pi = "pi"
    case e = "e"
    case log = "log"
    case power = "^"
    case decimal = "."
    case delete = "del"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .blue
        default:
            return .gray
        }
    }
    
    var buttonInfo: String {
        switch self{
        case .add:
            return "+"
        default:
            return rawValue
        }
    }
    var buttonImage: String {
        switch self {
        case .add:
            return "add"
        
        default:
            return "minus"
        }
    }

}

enum Operation {
    case add, subtract, multiply, divide, none
    
}

struct ContentView: View {
    
    @State var oldest_value = " "
    @State var older_value = " "
    @State var old_value = " "
    @State var value = "0"
    
    @State var cActive = "0"
    
    @State var runningNumber = Decimal(0)
    
    @State var currentOperation: Operation = .none
    
    let buttons: [[CalcButton]] = [
        [.clear, .answer, .pi, .e],
        [.add, .subtract, .multiply, .divide],
        [.seven, .eight, .nine, .power],
        [.four, .five, .six, .log],
        [.one, .two, .three, .decimal],
        [.delete, .zero, .equal]
    ]
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text("+calculator")
                    .foregroundColor(.blue)
                    .font(.system(size:30))
                    .bold()
                    .position(x: 192, y: -3)
                Spacer()
                // Text
             
                HStack{
                    Spacer()
                    VStack (spacing: 10){
                        Text(oldest_value)
                            .font(.system(size: 22))
                            .foregroundColor(Color(hue: 1.0, saturation: 0.023,brightness: 0.356, opacity: 1.0))
                        Text(older_value)
                            .font(.system(size: 32))
                            .foregroundColor(.gray)
                        Text(old_value)
                            .font(.system(size: 42))
                            .foregroundColor(.white)
                    }
                }
                HStack{
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 72))
                        .foregroundColor(.blue)
                }
                    
                .padding()
                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack (spacing: 0){
                        ForEach(row, id: \.self) {item in
                            Button(action : {
                                self.didTap(button: item)
                            }, label: {
                                HStack {
                                    Text(item.buttonInfo)
                                    //Image(item.buttonImage)
                                }
                                .frame(
                                    width: self.buttonWidth(item: item),
                                    height: self.buttonHeight(item: item))
                                .foregroundColor(.white)
                                .font(.system(size: 32))
                                .background(item.buttonColor)
                                .border(Color.black, width: 0.5)
                                
                            });
                       
                        }
                    }
                    .padding(.bottom, 0)
                }
            }
        }
    }
        
    func didTap(button: CalcButton){
        
        if self.value.contains("Error"){
            self.value = "0"
        }
        
        switch button {
        
        case .add, .subtract, .multiply, .divide, .equal:
        if button == .add{
            self.currentOperation = .add
            self.runningNumber = Decimal(string: self.value) ?? 0
        }
        else if button == .subtract{
            self.currentOperation = .subtract
            self.runningNumber = Decimal(string: self.value) ?? 0
        }
        else if button == .multiply{
            self.currentOperation = .multiply
            self.runningNumber = Decimal(string: self.value) ?? 0
        }
        else if button == .divide{
            self.currentOperation = .divide
            self.runningNumber = Decimal(string: self.value) ?? 0
        }
        else if button == .equal{
            
            // let runningValue = Int(self.runningNumber)
            let runningValue = self.runningNumber
            // let currentValue = Int(self.value) ?? 0
            let currentValue = Decimal(string: self.value)
            
            switch self.currentOperation {
            
                case .add:
                    let result = (runningValue + currentValue!)
                    self.value = "\(result)"
                    
                case .subtract: self.value = "\(runningValue - currentValue!)"
                case .multiply: self.value = "\(runningValue * currentValue!)"
                case .divide: self.value = "\(runningValue / currentValue!)"

                case .none:
                    break
            }
            
            self.oldest_value = self.older_value
            self.older_value = self.old_value
            self.old_value = self.value
        }
            
        if self.value == "NaN" {
            self.value = "Error"
        }
            
        if button != .equal {
            self.value = "0"
        }
            
       
        
        case .decimal:
            if self.value.contains(".") {
                self.value = "Error"
            }
            else{
                self.value = "\(self.value)."
            }
            
        case .clear:
            
            if cActive == "1" {
                self.oldest_value = "";
                self.older_value = "";
                self.old_value = "";
                self.cActive = "0"
            }
            else {
                self.cActive = "1"
            }
            
            self.value = "0"
            self.runningNumber = 0

        case .answer:
            self.value = "\(self.runningNumber)"
            
        case .power, .log, .delete:
            break
        
        case .pi:
            // aproximaciones
            self.value = "3.141593"
            
        case .e:
            // aproximaciones
            self.value = "2.718282"
        
        default:
            let number = button.rawValue
            
            if value == "0" {
                value = "\(number)"
            }
            
            else {
                self.value = "\(self.value)\(number)"
            }
        
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .equal{
            return 2 * (UIScreen.main.bounds.width) / 4
        }
        return (UIScreen.main.bounds.width)/4
    }
    
    func buttonHeight(item: CalcButton) -> CGFloat {
        return (UIScreen.main.bounds.width) / 5
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
