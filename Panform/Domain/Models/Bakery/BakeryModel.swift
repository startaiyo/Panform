//
//  BakeryModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import Foundation
import GoogleMaps

typealias BakeryID = UUID

struct BakeryModel {
    let id: BakeryID
    let name: String
    let openAt: TimeOnly?
    let closeAt: TimeOnly?
    let openingDays: [WeekDay]?
    let location: CLLocation
    let placeID: String
}

struct TimeOnly: Codable, Equatable {
    let hour: Int
    let minute: Int

    init?(hour: Int, minute: Int) {
        guard (0...23).contains(hour), (0...59).contains(minute) else {
            return nil
        }
        self.hour = hour
        self.minute = minute
    }

    var formatted: String {
        String(format: "%02d:%02d", hour, minute)
    }

    init?(from date: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        self.init(hour: hour, minute: minute)
    }

    func toDate() -> Date? {
        var components = DateComponents()
        components.hour = self.hour
        components.minute = self.minute
        return Calendar.current.date(from: components)
    }
}

enum WeekDay: String, Codable, CaseIterable {
    case mon, tue, wed, thu, fri, sat, sun
}

extension BakeryModel {
    static func stub() -> BakeryModel {
        return .init(id: UUID(),
                     name: "name",
                     openAt: .init(hour: 8,
                                   minute: 0)!,
                     closeAt: .init(hour: 16,
                                    minute: 0)!,
                     openingDays: [.mon, .tue],
                     location: .init(latitude: 50,
                                     longitude: 90),
                     placeID: "")
    }
}
