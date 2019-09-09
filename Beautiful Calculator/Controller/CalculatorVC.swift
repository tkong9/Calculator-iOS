//
//  ViewController.swift
//  Beautiful Calculator
//
//  Created by TAEWON KONG on 8/28/19.
//  Copyright © 2019 TAEWON KONG. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CalculatorVC: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
        
    private var displayValue: Double? {
        get {
            if let number = Double(displayLabel.text!) {
                return number
            }
            return nil
        }
        set {
            displayLabel.text = String(newValue!)
        }
    }
    
    var isNumberTurn: Bool = false
    
    var equalsButtonJustPressed: Bool = false //계산을 다 하고 다시 숫자를 누르면 누른 숫자만 표시하게끔 하는 불값.
    
    var dotDisabled: Bool = false
    
    var calculationHistories: Results<CalculationHistory>?
    
    var calculator = CalculatorLogic()
    
    let imageArray: [UIImage] = [UIImage(named: "green")!, UIImage(named: "blue")!, UIImage(named: "pink")!]
    
    var keepSameImage: Results<BackgroundImageNumber>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        isNumberTurn = true
        
        dotDisabled = false
        
        backgroundImage.image = imageArray[0]
        
        loadHistory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if keepSameImage?.count == 0 {
            let newNumber = BackgroundImageNumber()
            do {
                try realm.write {
                    realm.add(newNumber)
                }
            } catch {
                print("Error saving image number, \(error)")
            }
        } else {
            backgroundImage.image = imageArray[keepSameImage?[0].imageNumber ?? 0]
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if equalsButtonJustPressed {
            displayLabel.text = ""
        }
        if dotDisabled && sender.currentTitle == "." {
            return
        }
        if displayLabel.text! == "" && sender.currentTitle == "." {
            displayLabel.text! += sender.currentTitle!
            dotDisabled = true
        } else if displayLabel.text! != "" && sender.currentTitle! == "." {
            displayLabel.text! += sender.currentTitle!
            dotDisabled = true
        } else {
            displayLabel.text! += sender.currentTitle!
        }
        isNumberTurn = false
        equalsButtonJustPressed = false
    }
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        if isNumberTurn {
            return
        }

        guard let calcMethod = sender.currentTitle else {
            fatalError("Calculator Button was pressed, but string value is not found.")
        }
        
        equalsButtonJustPressed = false
        
        switch calcMethod {

        case "+/-":
            if let number = displayValue {
                displayValue = number * -1
            } else {
                return
            }
            dotDisabled = true
            
        case "%" :
            if let number = displayValue {
                displayValue = number * 0.01
            }
            dotDisabled = true
            return
            
        case "✕", "+":
            if displayLabel.text == "" {
                return
            }
            dotDisabled = false
            isNumberTurn = true
            displayLabel.text! += " " + sender.currentTitle! + " "
        
        case "÷":
        if displayLabel.text == "" {
            return
        }
        dotDisabled = false
        isNumberTurn = true
        displayLabel.text! += " " + sender.currentTitle! + " "
            
        case "-":
            dotDisabled = false
            isNumberTurn = true
            displayLabel.text! += " " + sender.currentTitle! + " "
        
        case "=":
            if displayLabel.text! == "" {
                return
            }
            dotDisabled = false
            equalsButtonJustPressed = true
            let result = calculator.calculate(displayLabel.text!)
            let newCalculation = CalculationHistory()
            newCalculation.calculation = "\(displayLabel.text!)" + "\n" + "= " + "\(result)"
            save(calculation: newCalculation)
            displayLabel.text = result
            
        default:
            print("Unexpected error has occured.")
        }
    }
    
    @IBAction func eraseButtonPressed(_ sender: UIButton) {
        if displayLabel.text!.count < 1 {
            return
        }
        if let lastChar = displayLabel.text?.last?.asciiValue {
            if lastChar >= 48 && lastChar <= 57 {
                displayLabel.text?.removeLast()
                return
            } else if lastChar == 46 {
                displayLabel.text?.removeLast()
                dotDisabled = false
            } else {
                displayLabel.text?.removeLast()
                displayLabel.text?.removeLast()
                displayLabel.text?.removeLast()
            }
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        displayLabel.text = ""
        isNumberTurn = true
        dotDisabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToHistory" {
            
            let destVC = segue.destination as! HistoryTableVC
            
            destVC.calculationHistories = calculationHistories

            destVC.imageArray = self.imageArray
            
            destVC.imageNumber = keepSameImage?[0].imageNumber ?? 0
        }
    }
    
    @IBAction func chageColorPressed(_ sender: UIBarButtonItem) {
        
        do {
            try realm.write {
                keepSameImage?[0].imageNumber += 1
                keepSameImage?[0].imageNumber %= 3
            }
        } catch {
            print("error changing image number, \(error)")
        }

        backgroundImage.image = imageArray[keepSameImage?[0].imageNumber ?? 0]
    }
    
    func save(calculation: CalculationHistory) {
        do {
            try realm.write {
                realm.add(calculation)
            }
        } catch {
            print("Error saving new calculation.")
        }
    }
    
    func loadHistory() {
        calculationHistories = realm.objects(CalculationHistory.self)
        keepSameImage = realm.objects(BackgroundImageNumber.self)
    }
}
