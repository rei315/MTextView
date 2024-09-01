//
//  MTextLayoutData.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import UIKit

public final class MTextLayoutData {
  let size: CGSize
  let attachmentViews: [(UIView, CGRect)]
  
  public init(size: CGSize, attachmentViews: [(UIView, CGRect)]) {
    self.size = size
    self.attachmentViews = attachmentViews
  }
}
