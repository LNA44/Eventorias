//
//  Event.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation
import SwiftUI

struct Event: Identifiable, Decodable, Hashable {
    var id: String
    var name: String
    var description: String
    var date: Date
    var location: String
    var category: String
    var guests: [String] // emails 
    var userID: String
    var imageURL: String?
    var isUserInvited: Bool = false
    
    init(id: String, name: String, description: String, date: Date, location: String, category: String, guests: [String],
         userID: String, imageURL: String? = nil, isUserInvited: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
        self.location = location
        self.category = category
        self.guests = guests
        self.userID = userID
        self.imageURL = imageURL
        self.isUserInvited = isUserInvited
    }
}
