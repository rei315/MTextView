//
//  MViewAttachment.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import UIKit

open class MViewAttachment: NSTextAttachment {
  public let offset: CGPoint
  public let textRect: CGRect
  
  public init(textRect: CGRect, offset: CGPoint = .zero) {
    self.textRect = textRect
    self.offset = offset
    super.init(data: nil, ofType: "application/view")
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage? {
    nil
  }
}

open class ViewAttachmentProvider: NSTextAttachmentViewProvider {
  public override init(textAttachment: NSTextAttachment, parentView: UIView?, textLayoutManager: NSTextLayoutManager?, location: any NSTextLocation) {
    super.init(textAttachment: textAttachment, parentView: parentView, textLayoutManager: textLayoutManager, location: location)
    tracksTextAttachmentViewBounds = true
  }
  
  public override func attachmentBounds(for attributes: [NSAttributedString.Key: Any], location: any NSTextLocation, textContainer: NSTextContainer?, proposedLineFragment: CGRect, position: CGPoint)
  -> CGRect
  {
    guard let attachment = textAttachment as? MViewAttachment else {
      return self.view?.bounds ?? .zero
    }
    return attachment.textRect
  }
}
