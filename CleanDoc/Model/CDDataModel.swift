//
//  CDDataModel.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 13/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
enum CDDataType: String {
    case requestTime = "Request Time"
    case requestDate = "Request Date"
    case exam = "Exam"
    case location = "Clinic Location"
    case notes = "Notes"
    case prescription = "Doctor's Prescription"
    case identification = "Provide Your Identification"
    case firstName = "First Name"
    case lastName = "Last Name"
    case dateOfBirth = "Date of Birth"
    
    static func appointment() -> [CDDataType] {
        return [.location, .exam, .requestDate, .requestTime, .notes, .prescription]
    }
    
    static func profile() -> [CDDataType] {
        return [.identification, .firstName, .lastName, .dateOfBirth]
    }
}

enum CDDataEntryType: String {
    case date = "Date"
    case time = "Time"
    case picklist = "Picklist"
    case textString = "TextString"
    case documentScan = "DocumentScan"
    case picture = "Picture"
}

protocol CDDataModelProtocol {
    var dataType: CDDataType {get}
    var entryType: CDDataEntryType {get}
    var value: Any {get set}
}

struct CDDataModel: CDDataModelProtocol {
    var value: Any
    var dataType: CDDataType
    var entryType: CDDataEntryType
}
