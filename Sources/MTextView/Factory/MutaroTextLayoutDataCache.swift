//
//  MutaroTextLayoutDataCache.swift
//  TestUIKit
//
//  Created by MINGUK KIM on 2024/09/01.
//

import Foundation

final class MutaroTextLayoutDataCache {
  private var _cache: [Int: MTextLayoutData] = [:]
  private let lock: NSLock = .init()
  
  private var cache: [Int: MTextLayoutData] {
    get {
      defer {
        lock.unlock()
      }
      lock.lock()
      return _cache
    }
    set {
      defer {
        lock.unlock()
      }
      lock.lock()
      _cache = newValue
    }
  }
  
  func data(for key: Int) -> MTextLayoutData? {
    cache[key]
  }
  
  func store(_ data: MTextLayoutData, for key: Int) {
    cache[key] = data
  }
  
  func removeAll() {
    cache.removeAll()
  }
}
