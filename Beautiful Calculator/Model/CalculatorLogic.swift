//
//  calculatorLogic.swift
//  Beautiful Calculator
//
//  Created by TAEWON KONG on 8/28/19.
//  Copyright © 2019 TAEWON KONG. All rights reserved.
//

import Foundation
import RealmSwift

class CalculatorLogic {
        
    var stringEquation: String = String()

    func toNSExpression(_ string: String) -> NSExpression {
        
        var nsExpression = string.replacingOccurrences(of: "÷", with: "/")
        
        nsExpression = nsExpression.replacingOccurrences(of: "✕", with: "*")

        return NSExpression(format: nsExpression).toFloatingPoint()
    }
    
    func calculate(_ stringEquation: String) -> String {
    
        let NSEquation = toNSExpression(stringEquation)

        let result = NSEquation.expressionValue(with: nil, context: nil)
        
        if let result = result {
            return "\(result)"
        } else {
            return "Syntax Error"
        }
    }
}

extension NSExpression {
    
    func toFloatingPoint() -> NSExpression {
        
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
            let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
            return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
            return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .anyKey:
            fatalError("anyKey not yet implemented")
        case .block:
            fatalError("block not yet implemented")
        case .evaluatedObject, .variable, .keyPath:
            break // Nothing to do here
        @unknown default:
            fatalError()
        }
        return self
    }
}
