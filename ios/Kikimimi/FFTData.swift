//
//  FFTData.swift
//  Kikimimi
//
//  Created by Jun Tanaka on 7/3/16.
//  Copyright © 2016 kirinsan.org. All rights reserved.
//

import Foundation

struct FFTData {
	let values: [Double]
}

extension FFTData: CustomStringConvertible {
	var description: String {
		return values.reduce("{ ", combine: { $0 + "\(String(format: "%.8f", $1)) " }) + "}"
	}
}
