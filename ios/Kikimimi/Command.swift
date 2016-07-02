//
//  Command.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import Foundation

struct Command {
	let id: String
	let name: String
	let icon: String
	let action: String
}

func ==(lhs: Command, rhs: Command) -> Bool {
	return lhs.id == rhs.id
}

extension Command: Hashable {
	var hashValue: Int {
		return id.hashValue
	}
}
