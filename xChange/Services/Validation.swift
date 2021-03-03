//
//  Validation.swift
//  xChange
//
//  Created by Alessio on 2021-02-02.
//

import Foundation
class Validate {
    static func email(_ email:String?) -> Bool{
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    static func password(_ password:String?)->Bool{
        guard let password = password else { return false }
        return password.count > 0
    }
    static func textFieldInput(_ text:String?)->Bool {
        guard let text = text else { return false }
        //TODO: Better input validation fx trimmed input count is more than x chars
        return text.count > 0
    }
}
