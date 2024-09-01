//
//  Applicable+.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import Foundation

public protocol Applicable {}
public extension Applicable {
    @discardableResult
    func apply(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

    func lets<R>(block: (Self) -> R) -> R {
        block(self)
    }
}

extension NSObject: Applicable {}
extension Int: Applicable {}
extension Int64: Applicable {}
extension Double: Applicable {}
extension String: Applicable {}
extension Array: Applicable {}
extension Bool: Applicable {}
