//
//  loggedinuser.swift
//  PakhisAthlinix
//
//  Created by admin65 on 21/12/24.
//

import Foundation

let loggedInUserID = "1"

//var sessionuser: UUID? /* = UUID()*/ /*UUID(uuidString: "20e33a9c-9e8e-4113-b56a-2a04b96f6b53")!*/


class SessionManager {
    static let shared = SessionManager() // Singleton instance

    private init() {} // Prevent external initialization

    var sessionUser: UUID? // The active user's UUID

    func setSessionUser(with uuidString: UUID) {
        sessionUser = uuidString
    }

    func getSessionUser() -> UUID? {
        return sessionUser
    }

    func clearSession() {
        sessionUser = nil
    }
}

