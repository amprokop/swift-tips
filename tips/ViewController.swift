//
//  ViewController.swift
//  tips
//
//  Created by Alex Prokop on 1/15/15.
//  Copyright (c) 2015 Alex Prokop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var dividingBar: UIView!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // When app enters foreground, we refresh the stored bill amount, in case we've cleared it in AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateBillAmountFromDefaults", name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        
        updateBillAmountFromDefaults()
        updateTipPercentageFromDefaults()
        updateThemeFromDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBillAmountFromDefaults()
        updateTipPercentageFromDefaults()
        updateThemeFromDefaults()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        defaults.setObject(billField.text, forKey: "currentBillAmount")
        defaults.synchronize()
    }
    
    func updateBillAmountFromDefaults() {
        let currentBillAmount : String? = defaults.objectForKey("currentBillAmount") as? String
        
        if let billAmount = currentBillAmount {
            billField.text = billAmount
        } else {
            tipLabel.text = "0.00"
            totalLabel.text  = "0.00"
        }
        
        onEditingChanged([:])
    }
    
    func updateTipPercentageFromDefaults() {
        let defaultTipControlIndex : String? = defaults.objectForKey("defaultTipControlIndex") as? String
        
        if let tipIndex = defaultTipControlIndex {
            tipControl.selectedSegmentIndex = tipIndex.toInt()!
        }
    }
    
    func updateThemeFromDefaults() {
        let themeName : String? = defaults.objectForKey("theme") as? String
        
        let black = UIColor.blackColor()
        let white = UIColor.whiteColor()
        
        //default to "Light"
        var background = white
        var foreground = black

        if themeName == "Dark" {
            background = black
            foreground = white
        }

        view.backgroundColor = background
        view.tintColor = foreground
        dividingBar.backgroundColor = foreground
        
        for sub in view.subviews {
            if sub.isKindOfClass(UILabel) {
                var label = sub as UILabel
                label.textColor = foreground
            }
        }
    }
    
    func formatNumberForLocale(num: Double) -> String{
        let identifier : String? = defaults.objectForKey("locale") as? String
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        if let localeIdentifier = identifier {
            formatter.locale = NSLocale(localeIdentifier: identifier!)
        } else {
            formatter.locale = NSLocale(localeIdentifier: "en_US")
        }
        
        return formatter.stringFromNumber(num)!
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        let tipPercentages  = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let billText = billField.text
        let billAmount = (billText as NSString).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip

        tipLabel.text = formatNumberForLocale(tip)
        totalLabel.text = formatNumberForLocale(total)
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

}

