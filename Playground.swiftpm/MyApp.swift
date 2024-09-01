import SwiftUI

@main
struct MyApp: App {
  var body: some Scene {
    WindowGroup {
      SampleView()
    }
  }
}

struct SampleView: UIViewControllerRepresentable {
  typealias UIViewControllerType = ViewController
  
  func makeUIViewController(context: Context) -> UIViewControllerType {
    ViewController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}
