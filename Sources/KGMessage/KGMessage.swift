//
//  KGMessage.swift
//  Special Order Keeper iPhone
//
//  Created by Kevin Green on 8/17/22.
//

import Foundation
import SwiftUI

public struct KGMessageContent {
    var subject: String
    var body: String
    
    public init(subject: String, body: String) {
        self.subject = subject
        self.body = body
    }
}
                                   
public class KGMessage {
    
    public init() {}
    
    /// Creates a KGMessage instance ready to send as an email message.
    ///
    /// - Paremeter content: The type of messageContent to apply to the email message.
    /// - Parameter addresses: An array of string containing the email addresses to sent the message to.
    public class func sendEmail(content: KGMessageContent, addresses: [String]) -> some View {
        return KGComposeMailView(result: .constant(nil), toRecipients: addresses, message: content, isHTML: false)
    }
    
    
    
    /// Creates a KGMessage instance ready to send as a SMS message.
    ///
    /// - Parameter content: The type of MessageContent to apply to the SMS message.
    /// - Parameter phoneNumber: The phone number to send the SMS messge to.
    public class func sendSMSText(content: KGMessageContent, phoneNumbers: [String]) -> KGComposeSMS {
        let cleanPhoneNumbers = phoneNumbers.map { $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
        return KGComposeSMS(smsResult: .constant(nil), recipients: cleanPhoneNumbers, messageContent: content, attachements: nil)
    }
    
    
    
    /// Starts a phone call.
    ///
    /// - Parameter phoneURL: Concatenates the phone number to call after the "telpromp:' prefix as a URL.
    public class func callphoneNumber(phoneNumber: String) {
        let cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let phoneURL = URL(string: "telprompt://\(cleanPhoneNumber)") /*, UIApplication.shared.canOpenURL(callPhoneURL)*/ {
            if #available(iOS 10, *) {
                UIApplication.shared.open(phoneURL)
            } else {
                UIApplication.shared.openURL(phoneURL)
            }
        }
    }
    
}




