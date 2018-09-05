//
//  ReminderViewController.swift
//  Todo
//
//  Created by Julie Wang on 2018-09-05.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {
    
    var todoListViewController: TodoListViewController?
    var todoIndexPath: IndexPath?
    var switchOn: Bool?
    var date: Date?

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBAction func handleSwitchToggle(_ sender: Any) {
        if reminderSwitch.isOn {
            reminderLabel.isHidden = false
            datePicker.isHidden = false
        } else {
            reminderLabel.isHidden = true
            datePicker.isHidden = true
        }
    }
    
    @IBAction func setReminder(_ sender: Any) {
        if let indexPath = todoIndexPath {
            if reminderSwitch.isOn {
                todoListViewController?.setReminder(indexPath: indexPath, date: datePicker.date)
            } else {
                todoListViewController?.setReminder(indexPath: indexPath, date: nil)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datePicker.date)
        reminderLabel.text = strDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if switchOn != nil {
            reminderSwitch.isOn = switchOn!
            reminderLabel.isHidden = !switchOn!
            datePicker.isHidden = !switchOn!
            if date != nil {
                datePicker.date = date!
            }
        }
    }
}
