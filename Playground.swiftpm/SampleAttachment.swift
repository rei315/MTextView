//
//  SampleAttachment.swift
//  Playground
//
//  Created by mingukkim on 2024/09/02.
//

import UIKit
import MTextView

final class SampleAttachment: MViewAttachment {
  let factory: SampleViewFactory
  
  static func make(textRect: CGRect, offset: CGPoint) -> SampleAttachment? {
    let factory = SampleViewFactory()
    guard factory.isAvailable() else {
      return nil
    }
    return .init(factory: factory, textRect: textRect, offset: offset)
  }
  
  private init(factory: SampleViewFactory, textRect: CGRect, offset: CGPoint) {
    self.factory = factory
    super.init(textRect: textRect, offset: offset)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewProvider(for parentView: UIView?, location: any NSTextLocation, textContainer: NSTextContainer?) -> NSTextAttachmentViewProvider? {
    SampleAttachmentProvider(
      textAttachment: self,
      parentView: parentView,
      textLayoutManager: textContainer?.textLayoutManager,
      location: location
    )
  }
}

final class SampleAttachmentProvider: ViewAttachmentProvider {
  override func loadView() {
    guard let attachment = textAttachment as? SampleAttachment else {
      view = UIView()
      return
    }
    view = attachment.factory.make()
  }
}
