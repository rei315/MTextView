//
//  MTextStorage.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import UIKit

public final class MTextStorage {
  var traitCollection: UITraitCollection = .current
  var yPadding: CGFloat = 0
  
  public init(traitCollection: UITraitCollection = .current, yPadding: CGFloat = 0) {
    self.traitCollection = traitCollection
    self.yPadding = yPadding
  }
}
