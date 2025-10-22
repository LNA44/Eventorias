//
//  ShareEventView.swift
//  Eventorias
//
//  Created by Ordinateur elena on 16/10/2025.
//

import UIKit
import SwiftUI

struct ActivityController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
