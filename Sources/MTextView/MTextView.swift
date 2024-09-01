//
//  MTextView.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import UIKit

public class MTextView: UIView {
  public var text: String {
    get { contentView.text }
    set { contentView.text = newValue }
  }
  
  public var attributedText: NSAttributedString? {
    get { contentView.attributedText }
    set { contentView.attributedText = newValue }
  }
  
  private let contentView = MTextContentView()
  
  public init(text: String) {
    super.init(frame: .zero)
    setupContentView()
    self.text = text
  }
  
  public init(text: NSAttributedString) {
    super.init(frame: .zero)
    setupContentView()
    self.attributedText = text
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupContentView()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupContentView()
  }
  
  private func setupContentView() {
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = bounds
    contentView.updateContentSizeIfNeeded()
  }
}
