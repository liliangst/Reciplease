//
//  TimeFormatter.swift
//  Reciplease
//
//  Created by Lilian Grasset on 24/07/2023.
//

import Foundation

class TimeFormatter {
    static func format(_ time: Int) -> String {
        let h = time / 60
        let m = time % 60
        guard h > 0 else {
            return "\(m)m"
        }
        guard m > 0 else {
            return "\(h)h"
        }
        return "\(h)h\(m)"
    }
}
