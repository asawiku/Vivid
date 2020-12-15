//
//  Extensions.swift
//  Vivid
//
//  Created by Asa on 19.02.2020.
//  Copyright © 2020 Anastasia Vikulova. All rights reserved.
//

import UIKit

extension String {
    func cityParsed() -> String {
        let part = split(separator: "/").dropFirst()
        let stringPart = part.joined(separator:"")
        return stringPart
    }
}
