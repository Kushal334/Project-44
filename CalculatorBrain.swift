//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by avi on 09/02/15.
//  Copyright (c) 2015 avi. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)

        var description: String {
            get {
                switch self {
                    case .Operand(let operand): return "\(operand)"
                    case .UnaryOperation(let symbol, _): return symbol
                    case .BinaryOperation(let symbol, _): return symbol
                }
            }
        }
    }
    // Alternatives:
    // var opStack: Array<Op> = Array<Op>()
    // var opStack = Array<Op>()
    private var opStack = [Op]()
    // Alternatives:
    // var knownOps = Dictionary<String, Op>()
    private var knownOps = [String: Op]()
    
    // init does not require func keyword
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("sin", sin))
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            // type of operation is Optional Op (CalculatorBrain.Op?)
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case Op.Operand(let operand):
                return (operand, remainingOps)
            case Op.UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                // following might work:
                //return (operation(operandEvaluation.result!), operandEvaluation.remainingOps)
                // however if result is nil, exception will be thrown and 
                // crash our app
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
                // now, in case result is nil, the if block will fail and // 
                // control will come out and return (nil, ops)
            
            case Op.BinaryOperation(_, let operation):
                let op1Evalution = evaluate(remainingOps)
                if let operand1 = op1Evalution.result {
                    let op2Evalution = evaluate(op1Evalution.remainingOps)
                    if let operand2 = op2Evalution.result {
                        return (operation(operand1, operand2), op2Evalution.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
}