//
//  User.swift
//  Eventorias
//
//  Created by Ordinateur elena on 10/10/2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String 
    let email: String
    var avatarURL: String?
    let name: String
}
