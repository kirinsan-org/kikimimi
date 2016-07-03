//
//  CommandCategory.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import Foundation

enum CommandCategory: Int {
	case c1 = 1
	case c2 = 2
	case c3 = 3
	case c4 = 4
	case c5 = 5
	case c6 = 6
	case c7 = 7
	case c8 = 8
	case c9 = 9
	case c10 = 10
	case c11 = 11
	case c12 = 12
	case c13 = 13
	case c14 = 14
	case c15 = 15
	case c16 = 16
	case c17 = 17
	case c18 = 18
	case c19 = 19
	case c20 = 20
	case c21 = 21
	case c22 = 22
	case c23 = 23
	case c24 = 24

	var imageName: String {
		return String(format: "pict_%02d.png", rawValue)
	}
}
