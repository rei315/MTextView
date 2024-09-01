//
//  SampleViewFactory.swift
//  Playground
//
//  Created by mingukkim on 2024/09/02.
//

import UIKit

final class SampleViewFactory {
  func make() -> UIView {
    let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 20, height: 20))
    imageView.image = .init(systemName: "pencil.circle.fill")
    return imageView
  }
  
  func isAvailable() -> Bool {
    true
  }
}
