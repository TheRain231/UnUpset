//
//  FeedbackView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 17.01.2025.
//


import SwiftUI
import MessageUI

struct FeedbackView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var subject: String
    var recipient: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: FeedbackView

        init(parent: FeedbackView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients([recipient])
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody("Describe your problem here:", isHTML: false)
        return mailComposeVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
