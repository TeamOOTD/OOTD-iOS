//
//  ODSDatePickerViewController.swift
//  OOTD-UIKit
//
//  Created by taekki on 2022/09/26.
//

import UIKit

import OOTD_Core

extension UIAlertController {
    public func set(vc: UIViewController?, width: CGFloat? = nil, height: CGFloat? = nil) {
        guard let vc = vc else { return }
        setValue(vc, forKey: "contentViewController")
        if let height = height {
            vc.preferredContentSize.height = height
            preferredContentSize.height = height
        }
    }
    
    public func addDatePicker(mode: UIDatePicker.Mode = .date, style: UIDatePickerStyle = .compact, date: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: ODSDatePickerViewController.Action?) {
        let datePicker = ODSDatePickerViewController(mode: mode, style: style, date: date, minimumDate: minimumDate, maximumDate: maximumDate, action: action)
        set(vc: datePicker, height: 217)
    }
}

final public class ODSDatePickerViewController: BaseViewController {
    
    public typealias Action = (Date) -> Void
    
    fileprivate var action: Action?
    
    fileprivate lazy var datePicker: UIDatePicker = { [unowned self] in
        $0.addTarget(self, action: #selector(actionForDatePicker), for: .valueChanged)
        return $0
    }(UIDatePicker())
    
    required init(mode: UIDatePicker.Mode, style: UIDatePickerStyle, date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: Action?) {
        super.init()
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = style
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.date = date ?? Date()
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        action?(datePicker.date)
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = datePicker
    }
    
    @objc func actionForDatePicker() {
        action?(datePicker.date)
    }
    
    public func setDate(_ date: Date) {
        datePicker.setDate(date, animated: true)
    }
}
