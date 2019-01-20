//
//  CDProfileViewModel.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 20/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
import UIKit
protocol CDProfileViewModelDelegate: class {
    func updateUserInterface()
}

protocol CDProfileViewModelProtocol {
    func updateUserInterface()
    init(delegate: CDProfileViewModelDelegate!)
}


class CDProfileViewModel: NSObject, CDProfileViewModelProtocol {
    weak var delegate: CDProfileViewModelDelegate!
    var fileInfo: FileInfo!
    var date: Date?
    
    required init(delegate: CDProfileViewModelDelegate!) {
        super.init()
        self.delegate = delegate
    }
    
    func updateUserInterface() {
        self.delegate?.updateUserInterface()
    }
    
    func fileSave(_ file: FileInfo) {
        self.fileInfo = file
        self.updateUserInterface()
    }
    
    func getDOB() -> String {
        return self.date?.getDateString("MMM dd, YYYY") ?? ""
    }
    
    func save(date: Date) {
        self.date = date
        self.updateUserInterface()
    }
    
    func getImage() -> UIImage? {
        guard let file = self.fileInfo, let idata = file.imageData else {
            return nil
        }
        return UIImage(data: idata)
    }
    
    func isValidProfile(firstName: String!, lastName: String!) -> (Bool, String, CDProfileModel?) {
        if firstName?.count == 0 || lastName?.count == 0 || self.fileInfo == nil || self.date == nil {
            return (false, "Incomplete data please fill", nil)
        }
        let mdoel = CDProfileModel.init(firstName: firstName, lastName: lastName, preFile: self.fileInfo, dob: self.date!)
        return (true, "", mdoel)
    }
}
