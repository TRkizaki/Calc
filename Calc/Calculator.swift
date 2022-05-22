//
//  Calculator.swift
//  Calc
//
//  Created by TRkizaki  on 22/5/2022.
//

import SwiftUI

struct Calculator : View {
    
    private let buttons = [
        ["AC", "⌫", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        [".", "0", "="],
    ]
    
    private let operators = ["÷", "+", "x", "%"]
    
    private let buttonWidth: CGFloat = (UIScreen.main.bounds.width - 40 ) / 4
    
    @State var visibleWorkings = ""
    @State var visibleResults = ""
    @State var showAlert = false
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Text(visibleWorkings)
                    .padding()
                    .foregroundColor(Color.yellow)
                    .font(.system(size: 30, weight: .regular))
                    .lineLimit(1)
                   }
                   .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    
            HStack {
                Spacer()
                Text(visibleResults)
                    .padding()
                    .foregroundColor(Color.yellow)
                    .font(.system( size: 50, weight: .regular))
              
                  }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
            ForEach(buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { cell in
                        Button (
                         action: { buttonPressed(cell: cell)},
                          label: {
                             Text(cell)
                                .frame(maxWidth: .infinity,
                                       maxHeight: .infinity)
                                .frame(width: cell == "0" ? buttonWidth * 2 + 10 : buttonWidth)
                                .foregroundColor(buttonColor(cell))
                                .font(.system( size: 30, weight: .regular))
                                .background(Color.yellow)
                                .cornerRadius(5)
                              })
                            }
                         }
                     }
         }
        .background(Color.blue.ignoresSafeArea())
    
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("Invalid Input"),
                message: Text(visibleWorkings),
                dismissButton: .default(Text("Okay"))
            )
        }
    }

  private func buttonColor(_ cell: String) -> Color {
    if(cell == "AC" || cell == "⌫") {
        return .red
    }
       if(cell == "-" || cell == "=" || operators.contains(cell)) {
        return .white
    }
      return .blue
  }

  private func buttonPressed(cell: String){
         switch cell {
         case "AC":
             visibleWorkings = ""
             visibleResults = ""
         case "⌫":
             visibleWorkings = String(visibleWorkings.dropLast())
         case "=":
             visibleResults = calculateResults()
         case "-":
             addMinus()
         case "÷":
             calculateDivision()
         case "%":
             calculatePercentage()
         case "x", "+":
             addOperator(cell)
         default:
             visibleWorkings += cell
         }
        
        
   func addOperator(_ cell : String){
            if !visibleWorkings.isEmpty{
                let last = String(visibleWorkings.last!)
                if operators.contains(last) || last == "-" {
                    visibleWorkings.removeLast()
                }
                if visibleWorkings.count >= 10 {
                    return
                }
                visibleWorkings += cell
            }
        }
      
   func addMinus(){
             if visibleResults.isEmpty || visibleWorkings.last! != "-"
             {
                 visibleWorkings += "-"
             }
        }
      
   func calculateDivision() {
          if visibleResults.isEmpty || visibleWorkings.last! != "÷"
          {
              visibleWorkings += "/"
          }
      }
      
   func calculatePercentage() {
          if visibleResults.isEmpty || visibleWorkings.last! != "%"
          {
              visibleWorkings += "*0.01"
          }
      }
    
   func calculateResults() -> String {
       if(validInput()){
       let workings = visibleWorkings.replacingOccurrences(of: "x", with: "*")
       let expression = NSExpression(format: workings)
       let result = expression.expressionValue(with: nil, context: nil) as! Double
       return formatResult(val: result)
       }
       showAlert = true
       return ""
   }
   
   func validInput() -> Bool {
       if(visibleWorkings.isEmpty) {
           return false
       }
       let last = String(visibleWorkings.last!)
       
       if(operators.contains(last) || last == "-") {
           if(last != "%" || visibleWorkings.count == 1) {
               return false
           }
       }
       return true
   }
   
    func formatResult(val: Double) -> String {
       if(val.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne))
       {
           return String(format: "%.0f", val)
       }
       return String(format: "%.2f", val)
    }
  }
}


struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Calculator()
                .navigationBarHidden(true)
        }
    }
}
