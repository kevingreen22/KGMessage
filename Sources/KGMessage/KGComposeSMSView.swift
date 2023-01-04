//
//  KGComposeSMSView.swift
//  Special Order Keeper iPhone
//
//  Created by Kevin Green on 8/11/22.
//

import SwiftUI
import UIKit
import MessageUI

public struct KGComposeSMS: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var smsResult: MessageComposeResult?
    var recipients: [String]
    var messageContent: KGMessageContent
    var attachements: [[AnyHashable : Any]]?
    
    private typealias MF = MFMessageComposeViewController
    
    public init(
        smsResult: Binding<MessageComposeResult?>,
        recipients: [String],
        messageContent: KGMessageContent,
        attachements: [[AnyHashable : Any]]? = nil
    ) {
        _smsResult = smsResult
        self.recipients = recipients
        self.messageContent = messageContent
        self.attachements = attachements
    }
    
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<KGComposeSMS>) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        
        if MF.canSendSubject() {
            vc.subject = messageContent.subject
        }
        
        vc.body = messageContent.body
        vc.messageComposeDelegate = context.coordinator
        
        
        //        if MF.canSendAttachments(), let attachements = attachements {
        //            for (_, atts) in attachements.enumerated() {
        //
        //                for dict in atts {
        //
        //
        //                }
        //            }
        //        }
        
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: UIViewControllerRepresentableContext<KGComposeSMS>) { }
    
    public func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    
    // MARK: Coordinator
    public class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: KGComposeSMS
        
        public init(_ parent: KGComposeSMS) {
            self.parent = parent
        }
        
        public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            defer {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
            
            self.parent.smsResult = result
        }
        
    }
    
}

