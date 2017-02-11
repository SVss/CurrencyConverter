//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Admin on 2/8/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var MainLabelOutlet: UILabel!
    @IBOutlet weak var InputTextOutlet: UITextField!
    @IBOutlet weak var ConvertButtonOutlet: UIButton!
    @IBOutlet weak var ScrollViewOutlet: UIScrollView!
    
    let alertController = UIAlertController(title: "Invalid input", message: "Please, enter valid positive decimal.", preferredStyle: .alert)
    let maxInputCharactersCount = 11
    
    let mainCurrencyName = "XBT"
    
    let exchangeRates: [(String, Double)] = [
        ("USD", 1_004.00),
        ("CNY", 6_820.50),
        ("EUR", 943.69),
        ("GBP", 804.21)
    ]
    
    var currencyLabels: Array<UILabel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainLabelOutlet.text = mainCurrencyName + ":"
        InputTextOutlet.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let defaultAlertAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.InputTextOutlet.becomeFirstResponder() })
        alertController.addAction(defaultAlertAction)
        
        generateLabels()
        
        InputTextOutlet.text = "0"
        setResults(value: 0)
    }

    func tapGestureAction(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text
            else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= maxInputCharactersCount
    }
    
    @IBAction func OnConvertTap(_ sender: UIButton) {
        let currentValue = Double(InputTextOutlet.text!)
        dismissKeyboard()
        updateResults(value: currentValue)
    }
    
    private func generateLabels() {
        let inputX = InputTextOutlet.frame.origin.x
        let inputWidth = InputTextOutlet.frame.width
        
        let mainLabelX = MainLabelOutlet.frame.origin.x
        let labelX = Int(trunc(mainLabelX))
        let labelWidth = Int(trunc(inputX - mainLabelX + inputWidth))
        
        let deltaY = 45
        var currentY = 0
        for _ in 1...exchangeRates.count {
            let newLabel = UILabel(frame: CGRect(x: labelX, y: currentY, width: labelWidth, height: 21))
            newLabel.textAlignment = .left
            newLabel.text = ""
            
            currencyLabels.append(newLabel)
            ScrollViewOutlet.addSubview(newLabel)
            
            currentY = currentY + deltaY
        }
    }
    
    private func updateResults(value: Double?) {
        guard let _value = value, _value >= 0
            else {
                setResults(value: 0)
                self.present(alertController, animated: true, completion: nil)
                return
        }
        setResults(value: _value)
    }
    
    private func setResults(value: Double) {
        for (i, (currName, exchange)) in exchangeRates.enumerated() {
            let result = value * exchange
            currencyLabels[i].text = getCurrencyText(name: currName, value: result)
        }
    }
    
    private func getCurrencyText(name: String, value: Double) -> String {
        let result = name + ": " + String(value)
        return result
    }
}

