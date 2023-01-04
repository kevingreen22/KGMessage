//
//  KGComposeMailView.swift
//  Special Order Keeper iPhone
//
//  Created by Kevin Green on 8/11/22.
//

import SwiftUI
import UIKit
import MessageUI

struct KGComposeMailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var result: Result<MFMailComposeResult, Error>?
    var toRecipients: [String]
    var message: KGMessageContent
    var isHTML: Bool = false
    var ccRecipients: [String]?
    var bccRecipients: [String]?
    var preferredSendingEmailAddress: String?
    var attatchments: [AttachmentDataSet]?
    
    typealias AttachmentDataSet = (attachment: Data, mimeType: String, filename: String)
    
    public init(
        result: Binding<Result<MFMailComposeResult, Error>?>,
        toRecipients: [String],
        message: KGMessageContent,
        isHTML: Bool,
        ccRecipients: [String]? = nil,
        bccRecipients: [String]? = nil,
        preferredSendingEmailAddress: String? = nil,
        attatchments: [(attachment: Data, mimeType: String, filename: String)]? = nil
    ) {
        _result = result
        self.toRecipients = toRecipients
        self.message = message
        self.isHTML = isHTML
        self.ccRecipients = ccRecipients
        self.bccRecipients = bccRecipients
        self.preferredSendingEmailAddress = preferredSendingEmailAddress
        self.attatchments = attatchments
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<KGComposeMailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(toRecipients)
        vc.setSubject(message.subject)
        vc.setMessageBody(message.body, isHTML: isHTML)
        vc.setCcRecipients(ccRecipients)
        vc.setBccRecipients(bccRecipients)
        
        if let prefAddress = preferredSendingEmailAddress {
            vc.setPreferredSendingEmailAddress(prefAddress)
        }

        if let attatchments = attatchments {
            for (_, att) in attatchments.enumerated() {
                vc.addAttachmentData(att.attachment, mimeType: att.mimeType, fileName: att.filename)
            }
        }
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<KGComposeMailView>) { }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    
    // MARK: Coordinator
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: KGComposeMailView
        
        init(_ parent: KGComposeMailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer { self.parent.presentationMode.wrappedValue.dismiss() }
            
            guard error == nil else {
                self.parent.result = .failure(error!)
                return
            }
            self.parent.result = .success(result)
        }
    }
    
}
