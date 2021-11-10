//
//  DatePickerViewController.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/05.
//

import UIKit
import MapKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.preferredDatePickerStyle = .wheels
    }
}
