//
//  MTextContentView.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import UIKit

public final class MTextContentView: UIView {
  var text: String {
    get { factory.attributedString()?.string ?? "" }
    set { setText(newValue) }
  }
  var attributedText: NSAttributedString? {
    get { factory.attributedString() }
    set { setText(newValue) }
  }
  
  private lazy var factory = MTextLayoutDataFactory()
  private let cache = MTextLayoutDataCache()
  private let storage = MTextStorage()
  
  private var layers = NSMapTable<NSTextLayoutFragment, MTextLayoutFragmentLayer>.weakToWeakObjects()
  private let contentLayer = MTextLayer()
  
  private var updatingLayers: Set<CALayer> = []
  private var updatingOffsets: Set<CGFloat> = []
  private var needUpdateLayout = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    setupContentLayer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    layers = .weakToWeakObjects()
    factory.setup(delegate: self)
  }
  
  private func setupContentLayer() {
    contentLayer.frame = bounds
    layer.addSublayer(contentLayer)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    if !needUpdateLayout {
      update(needUpdateViewport: true)
      contentLayer.frame = bounds
    }
  }
  
  public func update(needUpdateViewport: Bool = false) {
    if needUpdateViewport {
      factory.updateViewport()
    }
    let key = Int(bounds.size.width)
    let layoutData: MTextLayoutData
    if let data = cache.data(for: key) {
      layoutData = data
    } else {
      let data = factory.make(for: bounds.size, storage: storage)
      cache.store(data, for: key)
      layoutData = data
    }
    updateTextAttachments(with: layoutData.attachmentViews)
    updateContentSizeIfNeeded(needUpdateViewport: needUpdateViewport, layoutData: layoutData)
  }
  
  private func updateContentSizeIfNeeded(needUpdateViewport: Bool, layoutData: MTextLayoutData) {
    let layoutHeight = layoutData.size.height
    if layoutHeight != bounds.height {
      bounds.size.height = layoutHeight
      invalidateIntrinsicContentSize()
      setNeedsDisplay()
    }
  }
  
  private func updateTextAttachments(with attachmentViews: [(UIView, CGRect)]) {
    subviews
      .filter { !attachmentViews.map(\.0).contains($0) }
      .forEach { $0.removeFromSuperview() }
    
    attachmentViews
      .forEach { (view, frame) in
        if !subviews.contains(view) {
          addSubview(view)
        }
        view.frame = frame
      }
  }
  
  public override var intrinsicContentSize: CGSize {
    bounds.size
  }
  
  private func setText(_ string: String?) {
    let attributedString = string.map(NSAttributedString.init(string:))
    setText(attributedString)
  }
  
  private func setText(_ string: NSAttributedString?) {
    let attributedString = string.map(NSMutableAttributedString.init(attributedString:))
    factory.update(newValue: attributedString)
    layer.setNeedsLayout()
  }
}

extension MTextContentView: NSTextViewportLayoutControllerDelegate {
  public func viewportBounds(for textViewportLayoutController: NSTextViewportLayoutController) -> CGRect {
    bounds
  }
  
  public func textViewportLayoutControllerWillLayout(_ textViewportLayoutController: NSTextViewportLayoutController) {
    needUpdateLayout = true
    updatingLayers.removeAll()
    updatingOffsets.removeAll()
  }
  
  public func textViewportLayoutController(_ textViewportLayoutController: NSTextViewportLayoutController, configureRenderingSurfaceFor textLayoutFragment: NSTextLayoutFragment) {
    func findLayer() -> (MTextLayoutFragmentLayer, Bool) {
      if let layer = layers.object(forKey: textLayoutFragment) {
        return (layer, true)
      } else {
        let layer = MTextLayoutFragmentLayer(layoutFragment: textLayoutFragment, contentsScale: window?.screen.scale ?? 2)
        layers.setObject(layer, forKey: textLayoutFragment)
        return (layer, false)
      }
    }
    
    let (layer, isCached) = findLayer()
    if isCached {
      let oldPosition = layer.position
      let oldBounds = layer.bounds
      layer.updateGeometry()
      if oldBounds != layer.bounds {
        layer.setNeedsDisplay()
      }
      if oldPosition != layer.position {
        updatingOffsets.insert(oldPosition.y - layer.position.y)
      }
    }
    
    updatingLayers.insert(layer)
    contentLayer.addSublayer(layer)
  }
  
  public func textViewportLayoutControllerDidLayout(_ textViewportLayoutController: NSTextViewportLayoutController) {
    defer { needUpdateLayout = false }
    for layer in contentLayer.sublayers ?? [] where !updatingLayers.contains(layer) {
      layer.removeFromSuperlayer()
    }
    update()
  }
}
