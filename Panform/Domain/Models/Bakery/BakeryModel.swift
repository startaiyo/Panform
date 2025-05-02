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
    let memo: String
    let openAt: TimeOnly
    let closeAt: TimeOnly
    let openingDays: [WeekDay]
    let location: CLLocation
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
}

enum WeekDay: String, Codable, CaseIterable {
    case mon, tue, wed, thu, fri, sat, sun
}

extension BakeryModel {
    static func stub() -> BakeryModel {
        return .init(id: UUID(),
                     name: "name",
                     memo: "memo",
                     openAt: .init(hour: 8,
                                   minute: 0)!,
                     closeAt: .init(hour: 16,
                                    minute: 0)!,
                     openingDays: [.mon, .tue],
                     location: .init(latitude: 50,
                                     longitude: 90))
    }
}
