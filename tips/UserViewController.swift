//
//  UserViewController.swift
//  tips
//
//  Created by Alex Prokop on 1/16/15.
//  Copyright (c) 2015 Alex Prokop. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    var defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var currencyTypeControl: UISegmentedControl!
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var themeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        loadSavedSettings()
        onThemeChange([:])
        // Do any additional setup after loading the view.
    }
    
    func loadSavedSettings(){
        let tipControlIndex = defaults.objectForKey("defaultTipControlIndex") as? String
        let locale = defaults.objectForKey("locale") as? String
        let theme = defaults.objectForKey("theme") as? String
        
        if let tipStr = tipControlIndex {
            defaultTipControl.selectedSegmentIndex = tipStr.toInt()!
        }
        
        if let localeStr = locale {
            switch localeStr {
            case "en_US" :
                currencyTypeControl.selectedSegmentIndex = 0
            case "fr_FR":
                currencyTypeControl.selectedSegmentIndex = 1
            default: break
            }
        }
        
        if let themeStr = theme {
            switch themeStr {
            case "Light" :
                themeControl.selectedSegmentIndex = 0
            case "Dark" :
                themeControl.selectedSegmentIndex = 1
            default: break
            }
        }
    }
    
    
    @IBAction func dismissSettingsView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onThemeChange(sender: AnyObject) {
        let index = themeControl.selectedSegmentIndex
        let themeName = themeControl.titleForSegmentAtIndex(index)!
        
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
        
        for sub in view.subviews {
            if sub.isKindOfClass(UILabel) {
                var label = sub as UILabel
                label.textColor = foreground
            }
        }
        
        defaults.setObject(themeName, forKey: "theme")
        defaults.synchronize()
    }

    @IBAction func onCurrencyTypeChange(sender: AnyObject) {
        let identifiers = ["en_US", "fr_FR"]
        let index = currencyTypeControl.selectedSegmentIndex
        let identifier = identifiers[index]
        
        defaults.setObject(identifier, forKey: "locale")
        defaults.synchronize()
    }
    
    @IBAction func onDefaultTipChange(sender: AnyObject) {
        var tipPercentageIndex = defaultTipControl.selectedSegmentIndex
        var tipPercentageIndexString = String(tipPercentageIndex)
        
        defaults.setObject(tipPercentageIndexString, forKey: "defaultTipControlIndex")
        defaults.synchronize()
    }
}
