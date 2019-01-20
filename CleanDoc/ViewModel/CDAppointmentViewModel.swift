//
//  CDAppointmentViewModel.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 18/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol CDClinicModelProtocol {
    var latitude: Float {get set}
    var longitude: Float {get set}
    var clinicName: String! {get set}
    var id: String! {get set}
}

struct CDClinicModel: CDClinicModelProtocol {
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var clinicName: String! = ""
    var id: String! = ""
}

protocol CDClinicProcedureProtocol {
    var procedureName: String! {get set}
    var id: String! {get set}
}

struct CDClinicProcedureModel: CDClinicProcedureProtocol {
    var procedureName: String! = ""
    var id: String! = ""
}

protocol CDAppointmentViewModelDelegate: class {
    func updateUserInterface()
}

protocol CDAppointmentViewModelProtocol {
    func updateUserInterface()
    init(delegate: CDAppointmentViewModelDelegate!, profile: CDProfileModel!)
}

class CDAppointmentViewModel: NSObject, CDAppointmentViewModelProtocol {
    let display = CDDataType.appointment()
    var location: CDLocationService!
    
    var date: Date = Date()
    var fileInfo: FileInfo!
    var time: Date = Date()
    var clinics: [CDClinicModelProtocol] = [CDClinicModelProtocol]()
    var clinic: CDClinicModelProtocol!
    var procedure: CDClinicProcedureProtocol!
    var procedures: [CDClinicProcedureProtocol] = [CDClinicProcedureProtocol]()
    var profile: CDProfileModel!
    
    private weak var delegate: CDAppointmentViewModelDelegate!
    
    required init(delegate: CDAppointmentViewModelDelegate!, profile: CDProfileModel!) {
        super.init()
        self.delegate = delegate
        self.location = CDLocationService(delegate: nil)
        self.profile = profile
    }
    
    func set() {
        self.location.set(delegate: self)
    }
    
    func presInfo(_ save: FileInfo!) {
        self.fileInfo = save
        self.updateUserInterface()
    }
    
    func updateUserInterface() {
        if let loction = self.location.getCurrentLocation() {
            let filter = self.clinics.filter { (clinc) -> Bool in
                return loction.distance(from: CLLocation(latitude: CLLocationDegrees(clinc.latitude), longitude: CLLocationDegrees(clinc.longitude))) <= 1000.0
            }
            if let clinc = filter.first {
                self.clinic = clinc
            }
        }
        self.delegate?.updateUserInterface()
    }
    
    func pickerRows(for tag: Int) -> Int {
        switch tag {
        case 1:
            return self.clinics.count
        case 2:
            return self.procedures.count
        default:
            return 0
        }
    }
    
    func datePicker(for tag: Int) -> Date {
        switch tag {
        case 1:
            return self.date
        case 2:
            return self.time
        default:
            return Date()
        }
    }
    
    func updateDatePicker(for tag: Int, selection: Date) {
        switch tag {
        case 1:
            self.date = selection
        case 2:
            self.time = selection
        default:
            break
        }
        self.updateUserInterface()
    }
    
    func getTime() -> Date {
        return self.time
    }
    
    func getDate() -> Date {
        return self.date
    }
    
    func timeString() -> String {
        return self.time.getDateString("HH:mm")
    }
    
    func dateString() -> String {
        return self.date.getDateString("MMM dd, YYYY")
    }
    
    func selection(for tag: Int, at index: Int) {
        switch tag {
        case 1:
            self.clinic = self.clinics[index]
            self.procedure = nil
        case 2:
            self.procedure = self.procedures[index]
        default:
            break
        }
        self.updateUserInterface()
    }
    
    func getIndexOfClinic() -> Int {
        if let cl = self.clinic {
            let index = (self.clinics as NSArray).index(of: cl)
            return index
            
        }
        return 0
    }
    
    func getIndexOfProcedure() -> Int {
        if let cl = self.procedure {
            let index = (self.procedures as NSArray).index(of: cl)
            return index
        }
        return 0
    }
    
    func getName(for tag: Int, index: Int) -> String {
        switch tag {
        case 1:
            let cl = self.clinics[index]
            return cl.clinicName ?? "Pheonix"
        case 2:
            let cl = self.procedures[index]
            return cl.procedureName ?? "MRI"
        default:
            return ""
        }
    }
    
    
    func isClinicSelected() -> Bool {
        return self.clinic != nil
    }
    
    func clinicName() -> String {
        return self.clinic?.clinicName ?? "Pheonix"
    }
    
    func procedureName() -> String {
        return self.procedure?.procedureName ?? "MRI"
    }
    
    func imageForFile() -> UIImage? {
        return self.fileInfo != nil && self.fileInfo.imageData != nil ? UIImage(data: self.fileInfo.imageData!): nil
    }
    
}

extension CDAppointmentViewModel: CDLocationServiceDelegate {
    func locationRecieved() {
        self.updateUserInterface()
    }
}
