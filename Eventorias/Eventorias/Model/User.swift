//
//  User.swift
//  Eventorias
//
//  Created by Ordinateur elena on 10/10/2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String // le même que l'uid Firebase Auth
    let email: String
    let avatarURL: String?
}
