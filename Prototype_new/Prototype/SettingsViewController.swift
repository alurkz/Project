//
//  SettingsViewController.swift
//  Prototype
//
//  Created by Kevin Qian on 10/13/16.
//  Copyright © 2016 Kevin Qian. All rights reserved.
//

import UIKit

let TIME_INTERVAL = "Time Interval"

class SettingsViewController: UIViewController {
    
    
    ////////////
    //Tableview
    ////////////
    /*
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
        switch (indexPath.row) {
        case 0:
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil);
            cell.textLabel?.text = "Username";
            break;
        case 1:
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil);
            cell.textLabel?.text = "Notification Frequency";
            break;
        case 2:
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil);
            cell.textLabel?.text = "";
            break;
        default:
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil);
            cell.textLabel?.text = "Unused";
            break;
        }
        return cell;
    }

    func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableViewScrollPosition) {
        switch (indexPath!.row) {
        case 0:
            
            break;
        case 1:
            setSubviewVisible(true);
            break;
        case 2:
            
            break;
        default:
            
            break;
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            
            break;
        }
    }*/
    
    /*
    ///////////
    // Picker
    ///////////
    @IBOutlet var o_picker: UIPickerView!
    
    let pickerData = [["Every 10 seconds", "Every 30 seconds", "Every 1 minute", "Every 5 minutes", "Every 10 minutes", "∞ (Disable notification)"]];
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int
        ) -> Int {
        return pickerData[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
        ) -> String? {
        return pickerData[component][row]
    }
    
    func setPickerVisible(_ cond: Bool) {
        o_picker.isHidden = (!cond);
    }
    
    func updatePickerStorage(){
        switch o_picker.selectedRow(inComponent: 0) {
        case 0:
            UserDefaults.standard.setValue(10, forKey: TIME_INTERVAL);
            break;
        case 1:
            UserDefaults.standard.setValue(30, forKey: TIME_INTERVAL);
            break;
        case 2:
            UserDefaults.standard.setValue(60, forKey: TIME_INTERVAL);
            break;
        case 3:
            UserDefaults.standard.setValue(300, forKey: TIME_INTERVAL);
            break;
        case 4:
            UserDefaults.standard.setValue(1500, forKey: TIME_INTERVAL);
            break;
        case 5:
            UserDefaults.standard.setValue(-1, forKey: TIME_INTERVAL);
            break;
        default:
            break;
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        o_picker.delegate = self;
        o_picker.dataSource = self;
        setPickerVisible(false);
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
}

/*
class SettingsSubViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    ///////////
    // Picker
    ///////////
    @IBOutlet var o_picker: UIPickerView!
    
    let pickerData = [["Every 10 seconds", "Every 30 seconds", "Every 1 minute", "Every 5 minutes", "Every 10 minutes", "∞ (Disable notification)"]];
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int
        ) -> Int {
        return pickerData[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
        ) -> String? {
        return pickerData[component][row]
    }
    
    func setPickerVisible(_ cond: Bool) {
        o_picker.isHidden = (!cond);
    }
    
    func updatePickerStorage(){
        switch o_picker.selectedRow(inComponent: 0) {
        case 0:
            UserDefaults.standard.setValue(10, forKey: TIME_INTERVAL);
            break;
        case 1:
            UserDefaults.standard.setValue(30, forKey: TIME_INTERVAL);
            break;
        case 2:
            UserDefaults.standard.setValue(60, forKey: TIME_INTERVAL);
            break;
        case 3:
            UserDefaults.standard.setValue(300, forKey: TIME_INTERVAL);
            break;
        case 4:
            UserDefaults.standard.setValue(1500, forKey: TIME_INTERVAL);
            break;
        case 5:
            UserDefaults.standard.setValue(-1, forKey: TIME_INTERVAL);
            break;
        default:
            break;
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        o_picker.delegate = self;
        o_picker.dataSource = self;
        setPickerVisible(false);
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
 */

