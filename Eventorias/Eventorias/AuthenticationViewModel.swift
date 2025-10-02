//
//  AuthenticationViewModel.swift
//  Eventorias
//
//  Created by Ordinateur elena on 02/10/2025.
//

import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
	@Published var email: String = ""
	@Published var password: String = ""
	
}

