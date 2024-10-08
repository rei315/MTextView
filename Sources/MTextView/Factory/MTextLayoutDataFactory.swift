//
//  MTextLayoutDataFactory.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import UIKit

public final class MTextLayoutDataFactory {
  private let textLayoutManager: NSTextLayoutManager = .init()
  private let textContentStorage: NSTextContentStorage = .init()
  private let textContainer: NSTextContainer = .init()
  private let textStorage: NSTextStorage = .init()
  
  public init() {
    textLayoutManager.textContainer = textContainer
    textContentStorage.addTextLayoutManager(textLayoutManager)
    textContentStorage.textStorage = textStorage
    textContainer.lineFragmentPadding = 0
  }
  
  public func setup(delegate: NSTextViewportLayoutControllerDelegate) {
    textLayoutManager.textViewportLayoutController.delegate = delegate
  }
  
  public func attributedString() -> NSAttributedString? {
    textContentStorage.attributedString
  }
  
  public func update(newValue: NSAttributedString?) {
    textContentStorage.performEditingTransaction {
      textContentStorage.attributedString = newValue
    }
  }
  
  public func updateViewport() {
    textLayoutManager.textViewportLayoutController.layoutViewport()
  }
  
  @MainActor
  public func make(for size: CGSize, storage: MTextStorage) -> MTextLayoutData {
    textContainer.size = size
    
    var layoutWidth: Double = 0
    var layoutHeight: Double = 0
    var textAttachmentViews: [(UIView, CGRect)] = []
    textLayoutManager.enumerateTextLayoutFragments(from: nil, options: [.ensuresLayout, .ensuresExtraLineFragment]) { fragment in
      for provider in fragment.textAttachmentViewProviders {
        guard let attachmentView = provider.view else {
          continue
        }
        var attachmentViewFrame = fragment.frameForTextAttachment(
          at: provider.location
        )
        guard !attachmentViewFrame.isEmpty else {
          continue
        }
        if let customAttachment = provider.textAttachment as? MViewAttachment {
          attachmentViewFrame = attachmentViewFrame.offsetBy(
            dx: -customAttachment.offset.x,
            dy: -customAttachment.offset.y
          )
        }
        let frame = attachmentViewFrame.offsetBy(
          dx: 0,
          dy: fragment.layoutFragmentFrame.minY
        )
        textAttachmentViews.append((attachmentView, frame))
      }
      layoutWidth = max(fragment.layoutFragmentFrame.width, layoutWidth)
      layoutHeight = max(fragment.layoutFragmentFrame.maxY, layoutHeight)
      return true
    }
    let layoutSize: CGSize = .init(width: layoutWidth, height: layoutHeight)
    
    return .init(size: layoutSize, attachmentViews: textAttachmentViews)
  }
  
  @MainActor
  public func layout(for size: CGSize, storage: MTextStorage) -> CGSize {
    textContainer.size = size
    
    var layoutWidth: Double = 0
    var layoutHeight: Double = 0
    textLayoutManager.enumerateTextLayoutFragments(from: nil, options: [.ensuresLayout, .ensuresExtraLineFragment]) { fragment in
      layoutWidth = max(fragment.layoutFragmentFrame.width, layoutWidth)
      layoutHeight = max(fragment.layoutFragmentFrame.maxY, layoutHeight)
      return true
    }
    let layoutSize: CGSize = .init(width: layoutWidth, height: layoutHeight)
    return layoutSize
  }
}

