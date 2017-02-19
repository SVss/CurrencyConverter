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
    
    let alertController = UIAlertController(
        title: "Invalid input",
        message: nil,
        preferredStyle: .alert
    )
    
    let maxInputCharactersCount = 11
    let mainCurrencyName = "XBT"
    let exchangeRates: [(String, Double)] = [
        ("USD", 1_004.00),
        ("CNY", 6_820.50),
        ("EUR", 943.69),
        ("GBP", 804.21),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90),
        ("RRR", 90)
    ]
    
    var currencyLabels: Array<UILabel> = []
    let currencyLabelHeight = 21
    let currencyLabelsDeltaY = 45
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        resetResults()
    }

    private func prepareView() {
        MainLabelOutlet.text = mainCurrencyName + ":"
        InputTextOutlet.delegate = self
        
        setKeyboardHide()
        setDefaultAlertAction()
        generateLabels(ScrollViewOutlet)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setKeyboardHide() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func tapGestureAction(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setDefaultAlertAction() {
        let defaultAlertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: {
                (alert: UIAlertAction!) in
                self.InputTextOutlet.becomeFirstResponder()
            }
        )
        alertController.addAction(defaultAlertAction)
    }
    
    private func generateLabels(_ scrollView: UIScrollView) {
        currencyLabels = []
        
        let inputX = InputTextOutlet.frame.origin.x
        let inputWidth = InputTextOutlet.frame.width
        
        let mainLabelX = MainLabelOutlet.frame.origin.x
        let labelX = Int(trunc(mainLabelX))
        let labelWidth = Int(trunc(inputX - mainLabelX + inputWidth))
        
        var currentY = 0
        for _ in 1...exchangeRates.count {
            let newLabel = UILabel(frame: CGRect(x: labelX, y: currentY, width: labelWidth, height: currencyLabelHeight))
            newLabel.textAlignment = .left
            newLabel.text = ""
            
            currencyLabels.append(newLabel)
            scrollView.addSubview(newLabel)
            
            currentY = currentY + currencyLabelsDeltaY
        }
        
        scrollView.contentSize = CGSize(width: ScrollViewOutlet.contentSize.width, height: CGFloat(currentY))
    }
    
    private func resetResults() {
        InputTextOutlet.text = "0"
        setResults(0)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("keyboard will show!")
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboard will hide!")
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
        if let valueString = InputTextOutlet.text {
            if valueString.characters.count == 0 {
                resetResults()
            } else {
                let currentValue = Double(valueString)
                if updateResults(value: currentValue) {
                    dismissKeyboard()
                }
            }
        } else {
            showErrorMessage("Input expected.")
        }
        
    }
    
    private func updateResults(value: Double?) -> Bool {
        var result = false
        if let _value = value {
            if _value >= 0 {
                setResults(_value)
                result = true
            } else {
                setResults(0)
                showErrorMessage("Please, enter positive decimal.")
            }
        } else {
            setResults(0)
            showErrorMessage("Expected decimal, got string.")
        }
        return result
    }
    
    private func setResults(_ value: Double) {
        for (i, (currName, exchange)) in self.exchangeRates.enumerated() {
            let result = value * exchange
            currencyLabels[i].text = getCurrencyText(name: currName, value: result)
        }
    }
    
    private func getCurrencyText(name: String, value: Double) -> String {
        let result = name + ": " + String(value)
        return result
    }
    
    private func showErrorMessage(_ message: String) {
        self.alertController.setValue(message, forKey: "message")
        self.present(alertController, animated: true, completion: nil)
    }
}

