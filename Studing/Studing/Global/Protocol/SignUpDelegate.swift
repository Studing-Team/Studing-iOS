//
//  SignUpDelegate.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

protocol InputUserInfoDelegate: AnyObject {
    func didSubmitUserId(_ userId: String)
    func didSubmitPassword(_ password: String)
}

protocol InputUniversityNameDelegate: AnyObject {
    func didSubmitUniversityName(_ name: String)
}

protocol InputMajorDelegate: AnyObject {
    func didSubmitMajor(_ major: String)
}

protocol InputAdmissionDelegate: AnyObject {
    func didSubmitAdmission(_ admission: String)
}

protocol InputStudentInfoDelegate: AnyObject {
    func didSubmitStudentCardImage(_ imageData: Data)
    func didSubmitUserName(_ userName: String)
    func didSubmitStudentNumber(_ studentNumber: String)
}
