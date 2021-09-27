//
//  ViewController.swift
//  Calculator
//
//  Created by avi on 07/02/15.
//  Copyright (c) 2015 avi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var userHasEnteredADot = false
    
    var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get {
            let text = display.text!
            if text == "π" {
                return M_PI
            }
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "π" {
            if userIsInTheMiddleOfTypingANumber {
                return
            }
            else {
                display.text = digit
                enter()
                return
            }
        }
        
        if digit == "." {
            if userHasEnteredADot {
                return
            }
            else {
                userHasEnteredADot = true
            }
        }
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
    }
    
    @IBAction func operrate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            // history needs to be improved
            // for example, it enters operations into display even though
            // they are not getting evaluated 
            // enter 9 enter + enter + enter 3 etc.
            history.text! += operation + "|"
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
            else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        userHasEnteredADot = false
        history.text! += display.text! + "|"
        // needs unwrapping of optional displayValue! and a if block?
        // change it later
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        }
        else {
            displayValue = 0
        }
    }
    
    @IBAction func clear() {
        history.text = "history: "
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false
        userHasEnteredADot = false
        println("Calculator has been reset")
        brain = CalculatorBrain()
    }
    
    @IBAction func backspace() {
        if countElements(display.text!) > 0 {
            display.text = dropLast(display.text!)
            if display.text!.isEmpty {
                userIsInTheMiddleOfTypingANumber = false
                display.text = "0"
            }
        }
    }
    
    @IBAction func changeSign() {
        displayValue = -(displayValue!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

