//
//  DatePicker.swift
//  Practice
//
//  Created by Siddhesh jadhav on 30/05/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class DatePicker: UIView {
    
    
    @IBOutlet var contentView: DatePicker!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed("CustomDatePicker", owner: self, options: nil)
        //        addSubview(containerView)
        //        containerView.frame = self.bounds
        //        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        contentView.fixInView(self)
    }
    
    func setDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        yearLbl.text = formatter.string(from: datePicker.date)
        formatter.dateFormat = "E, d MMM"
        dateLbl.text = formatter.string(from: datePicker.date)
    }
    
    override func awakeFromNib() {
        setDate()
    }
    
    @IBAction func cancelAcrtion(_ sender: UIButton) {
        print("cancel tapped")
        let cal = NSCalendar.current
        let dateFatertwoMonth = cal.date(byAdding: .month, value: 0, to: Date())!
        datePicker.setDate(dateFatertwoMonth, animated: true)
        setDate()
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        print("ok tapped")
//        let cal = NSCalendar.current
//        let dateFaterSixMonth = cal.date(byAdding: .month, value: 6, to: Date())!
        var components = DateComponents()
        components.month = 8
        components.day = 6
        let date = Calendar.current.date(from: components)!
        datePicker.setDate(date, animated: true)
        setDate()
    }
}


extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

