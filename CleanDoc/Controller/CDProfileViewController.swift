//
//  CDProfileViewController.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 18/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
import UIKit
struct CDProfileModel {
    var firstName: String
    var lastName: String
    var preFile: FileInfo
    var dob: Date
}

class CDProfileViewController: CDViewController, MediaPickerPresenter, UITextFieldDelegate, CDProfileViewModelDelegate {
    
    var viewModel: CDProfileViewModel!
    
    @IBOutlet var datePickerContainer: UIView!
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var dateOfBirthField: UITextField!
    
    @IBOutlet var heightOfDatePickerView: NSLayoutConstraint!
    
    @IBOutlet var dateTimePicketView: UIDatePicker!
    var tap: UITapGestureRecognizer! = nil
    @IBOutlet var dateTimePicketSave: UIButton!
    
    @IBOutlet var contaner_1: UIView! {
        didSet {
            self.contaner_1?.layer.cornerRadius = 2.0
            self.contaner_1?.clipsToBounds = true
        }
    }
    
    @IBAction func didDeactivateNotes(_ sender: UIGestureRecognizer!) {
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        self.view.removeGestureRecognizer(sender)
    }
    
    var attachmentManager: AttachmentManager = AttachmentManager()
    
    @IBAction func openImageGallery() {
        self.presentAttachmentActionSheet()
    }
    
    @IBAction func cancel(_ sender: UIButton!) {
        self.heightOfDatePickerView?.constant = 0.0
        self.datePickerContainer?.isHidden = true
    }
    
    @IBAction func saveDatePicker(_ sender: UIButton!) {
        self.viewModel.save(date: self.dateTimePicketView.date)
        self.cancel(nil)
    }
    
    @IBAction func addAppointment() {
        let tuple = self.viewModel.isValidProfile(firstName: self.firstNameField?.text ?? "", lastName: self.lastNameField?.text ?? "")
        if tuple.0 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CDAppointmentViewController") as? CDAppointmentViewController {
                let viewModel = CDAppointmentViewModel(delegate: vc, profile: tuple.2)
                vc.viewModel = viewModel
                self.present(vc, animated: true, completion: nil)
            }
        } else {
            self.openErrorAlert(message: tuple.1)
        }
        
    }
    
    func openErrorAlert(message: String) {
        let alert = UIAlertController(title: "Clear Doc Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CDProfileViewModel(delegate: self)
        self.viewModel.updateUserInterface()
        var titles = attachmentManager.settings.titles
        var settings = attachmentManager.settings
        
        //Customize titles
        titles.actionSheetTitle = "Choose Document"
        titles.cancelTitle = "CANCEL"
        
        //Customize pickers settings
        settings.allowedAttachments = [.photoLibrary, .camera];
        settings.documentTypes = ["public.image", "public.data"];
        
        settings.libraryAllowsEditing = true
        settings.cameraAllowsEditing = true
    }
    
    func didSelectFromMediaPicker(_ file: FileInfo) {
        self.contaner_1.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.viewModel.fileSave(file)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.dateOfBirthField:
            self.datePickerContainer.isHidden = false
            self.heightOfDatePickerView?.constant = 200.0
            self.dateTimePicketView.maximumDate = Date()
            self.dateTimePicketView.datePickerMode = .date
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.firstNameField.resignFirstResponder()
            self.lastNameField.resignFirstResponder()
            return false
        default:
            self.tap = UITapGestureRecognizer(target: self, action: #selector(self.didDeactivateNotes(_:)))
            self.view.addGestureRecognizer(self.tap)
            return true
        }
    }
    
    func updateUserInterface() {
        self.dateOfBirthField?.text = self.viewModel.getDOB()
        self.cancel(nil)
        if let image = self.viewModel.getImage() {
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.contaner_1.frame.size.width, height: self.contaner_1.frame.size.height))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            self.contaner_1.addSubview(imageView)
        }
    }
}
