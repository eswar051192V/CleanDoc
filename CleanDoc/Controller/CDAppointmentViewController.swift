//
//  CDAppointmentViewController.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 18/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
import UIKit

class CDAppointmentViewController: CDViewController, MediaPickerPresenter {
    var attachmentManager: AttachmentManager = AttachmentManager()
    
    @IBOutlet var locationField: UITextField!
    @IBOutlet var examField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var timeField: UITextField!
    @IBOutlet var notesField: UITextView! {
        didSet {
            notesField.layer.borderWidth = 1
            notesField.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet var heightOfPickerView: NSLayoutConstraint!
    @IBOutlet var heightOfDatePickerView: NSLayoutConstraint!
    
    @IBOutlet var datePickerContainer: UIView!
    @IBOutlet var pickerContainer: UIView!
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var dateTimePicketView: UIDatePicker!
    
    @IBOutlet var pickerViewSave: UIButton!
    @IBOutlet var dateTimePicketSave: UIButton!
    @IBOutlet var bottomLayout: NSLayoutConstraint!
    @IBOutlet var topLayout: NSLayoutConstraint!
    
    @IBOutlet var contaner_1: UIView! {
        didSet {
            self.contaner_1?.layer.cornerRadius = 2.0
            self.contaner_1?.clipsToBounds = true
        }
    }
    
    var tap: UITapGestureRecognizer! = nil
    var viewModel: CDAppointmentViewModel!
    
    @IBAction func openImageGallery() {
        presentAttachmentActionSheet()
    }
    
    @IBAction func cancel(_ sender: UIButton!) {
        self.heightOfPickerView?.constant = 0.0
        self.pickerContainer?.isHidden = true
        self.datePickerContainer?.isHidden = true
        self.heightOfDatePickerView?.constant = 0.0
    }
    
    @IBAction func savePicker(_ sender: UIButton!) {
        self.viewModel.selection(for: self.pickerView.tag, at: self.pickerView.selectedRow(inComponent: 0))
        self.cancel(nil)
    }
    
    @IBAction func saveDatePicker(_ sender: UIButton!) {
        self.viewModel.updateDatePicker(for: self.dateTimePicketView.tag, selection: self.dateTimePicketView.date)
        self.cancel(nil)
    }
    
    func didSelectFromMediaPicker(_ file: FileInfo) {
        self.contaner_1.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.viewModel.presInfo(file)
    }
    
    @IBAction func didDeactivateNotes(_ sender: UIGestureRecognizer!) {
        self.notesField.resignFirstResponder()
        self.view.removeGestureRecognizer(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.set()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.adjustViewWRTFrame()
    }
    
    func adjustViewWRTFrame() {
        self.view.layoutIfNeeded()
        self.view.addKeyboardPanning { (keybaordFrame, open, close) in
            let boundsHeight = UIScreen.main.bounds.height
            let keyboardY = keybaordFrame.origin.y
            
            UIView.animate(withDuration: 0.3, animations: {
                if open {
                    self.bottomLayout?.constant = (boundsHeight - keyboardY)
                    self.topLayout?.constant = -(boundsHeight - keyboardY) + 150.0
                }
                
                if close {
                    self.bottomLayout?.constant = 60.0 + self.view.safeAreaInsets.bottom
                    self.topLayout?.constant = 0
                }
                
                self.view.layoutIfNeeded()
            })
        }
    }

}

extension CDAppointmentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.pickerRows(for: pickerView.tag)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.getName(for: pickerView.tag, index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension CDAppointmentViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.notesField.resignFirstResponder()
        switch textField {
        case locationField:
            self.pickerView.tag = 1
            self.pickerViewSave.tag = 1
            self.pickerView.selectRow(self.viewModel.getIndexOfClinic(), inComponent: 0, animated: true)
            self.heightOfPickerView?.constant = 200.0
            self.pickerContainer?.isHidden = false
            self.datePickerContainer?.isHidden = true
            break
        case examField:
            if self.viewModel.isClinicSelected() {
                self.pickerView.tag = 2
                self.pickerViewSave.tag = 2
                self.pickerView.selectRow(self.viewModel.getIndexOfProcedure(), inComponent: 0, animated: true)
                self.heightOfPickerView?.constant = 200.0
                self.pickerContainer?.isHidden = false
                self.datePickerContainer?.isHidden = true
            } else {
                self.cancel(nil)
                self.openErrorAlert(message: "Clinic has to be selected")
            }
            
            break
        case dateField:
            self.dateTimePicketView.datePickerMode = .date
            self.dateTimePicketView.tag = 1
            self.dateTimePicketView.date = self.viewModel.getDate()
            self.dateTimePicketSave.tag = 1
            self.heightOfDatePickerView?.constant = 200.0
            self.dateTimePicketView?.minimumDate = Date()
            self.pickerContainer?.isHidden = true
            self.datePickerContainer?.isHidden = false
            break
        case timeField:
            self.dateTimePicketView.datePickerMode = .time
            self.dateTimePicketView.date = self.viewModel.getTime()
            self.dateTimePicketSave.tag = 2
            self.dateTimePicketView.tag = 2
            self.heightOfDatePickerView?.constant = 200.0
            self.pickerContainer?.isHidden = true
            self.datePickerContainer?.isHidden = false
            break
        default:
            break
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        return false
    }
    
    func openErrorAlert(message: String) {
        let alert = UIAlertController(title: "Clear Doc Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.tap = UITapGestureRecognizer(target: self, action: #selector(self.didDeactivateNotes(_:)))
        self.view.addGestureRecognizer(self.tap)
        return true
    }
}

extension CDAppointmentViewController: CDAppointmentViewModelDelegate {
    func updateUserInterface() {
        self.locationField.text = self.viewModel.clinicName()
        self.examField.text = self.viewModel.procedureName()
        self.timeField.text = self.viewModel.timeString()
        self.dateField.text = self.viewModel.dateString()
        
        if let image = self.viewModel.imageForFile() {
            self.contaner_1.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.contaner_1.frame.size.width, height: self.contaner_1.frame.size.height))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            self.contaner_1.addSubview(imageView)
        }
       
    }
}
