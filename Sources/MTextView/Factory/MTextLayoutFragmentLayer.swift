//
//  MTextLayoutFragmentLayer.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import UIKit

final class MTextLayoutFragmentLayer: MTextLayer {
  private var layoutFragment: NSTextLayoutFragment
  
  init(layoutFragment: NSTextLayoutFragment, contentsScale: CGFloat) {
    self.layoutFragment = layoutFragment
    super.init()
    self.contentsScale = contentsScale
    isOpaque = false
    drawsAsynchronously = true
    updateGeometry()
    setNeedsDisplay()
  }
  
  override init(layer: Any) {
    let layer = layer as! MTextLayoutFragmentLayer
    layoutFragment = layer.layoutFragment
    super.init(layer: layer)
    contentsScale = layer.contentsScale
    rasterizationScale = layer.rasterizationScale
    updateGeometry()
    setNeedsDisplay()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func draw(in ctx: CGContext) {
    layoutFragment.draw(at: .zero, in: ctx)
  }
  
  func updateGeometry() {
    var bounds = layoutFragment.renderingSurfaceBounds
    anchorPoint = CGPoint(x: -bounds.origin.x / bounds.width,
                          y: -bounds.origin.y / bounds.height)
    position = layoutFragment.layoutFragmentFrame.origin
    bounds.origin.x += position.x
    self.bounds = bounds
  }
}
