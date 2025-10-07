//
//  Event.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation

struct Event: Identifiable, Decodable, Hashable {
    var id: String
    var name: String
    var date: Date
    var imageURL: String?
    var userProfileImageURL: String
}
