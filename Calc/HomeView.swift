//
//  HomeView.swift
//  Calc
//
//  Created by DJ perrier  on 20/5/2022.
//

import SwiftUI

enum CalculateState {
    case initial, add, subtract, divide, multiple, sum
}

struct HomeView: View {
    
    private let buttons = [//calculateItems
        ["AC", "⌫", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        [".", "0", "="],
    ]
    
    private let operators = ["÷", "+", "x", "%"]
    
    private let buttonWidth: CGFloat = (UIScreen.main.bounds.width - 40 ) / 4
    
    @State var visibleWorkings = "" //selectedItems //selectedNumber
    @State var visibleResults = "" //calculateNumber
    @State var calculateState: CalculateState = .initial
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
                //Text(visibleResults == "0" ? checkDecimal(visibleResults: visibleResults) : visibleWorkings)//56:14
                    .padding()
                    .foregroundColor(Color.yellow)
                    .font(.system( size: 50, weight: .regular))
                   // .minimumScaleFactor(0.4)
                  }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
            ForEach(buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { cell in
                        Button (
                         action: { buttonPressed(cell: cell)},
                          label: {
                             Text(cell)
                                .frame(minWidth: 0, maxWidth: .infinity,
                                       minHeight: 0 ,maxHeight: .infinity)
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
    
    private func checkDecimal(visibleResults: Double) -> String {
        if visibleResults.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne) {
            return String(Int(visibleResults))
        } else {
            return String(visibleResults)
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

  private func buttonPressed(cell: String){ //handleButtonInfo 36:50
    
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
             addDivide()
         case "x", "%", "+":
             addOperator(cell)
//         case ".":
//             addComma(cell)
         default:
             visibleWorkings += cell
         }
        
        
   func addOperator(_ cell : String){
       //guard let visibleOperation = Double(visibleWorkings) else { return }
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
         
     }
    
    func addDivide(){
        
    }
    
//    func addComma(_ cell: String) {
//        if cell == "." && (visibleWorkings.contains(".") || visibleWorkings.contains("0")) {
//            return
//        }
//    }
    
//    private func calculate(visibleWorking: Double) {
//
//        switch calculateState {
//
//        case .add:
//            <#code#>
//        case .subtract:
//            <#code#>
//        case .divide:
//            visibleResults =
//        case .multiple:
//            <#code#>
//        default:
//            break
//        }
//
//    }
    
   
    private func calculateResults() -> String {
  
       if(validInput()){
       var workings = visibleWorkings.replacingOccurrences(of: "%", with: "*0.01")
       workings = visibleWorkings.replacingOccurrences(of: "x", with: "*")
       //workings = visibleWorkings.replacingOccurrences(of: "÷", with: "/")
       let expression = NSExpression(format: workings)
       let result = expression.expressionValue(with: nil, context: nil) as! Double
       return formatResult(val: result)
       }
       showAlert = true
       return ""
   }
   
   private func validInput() -> Bool {
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
   
   private func formatResult(val: Double) -> String
   {
       if(val.truncatingRemainder(dividingBy: 1) == 0)//
       {
           return String(format: "%.0f", val)
       }
       return String(format: "%.2f", val)
   }
    
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
    }
}
