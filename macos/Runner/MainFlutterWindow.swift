import Cocoa
import Firebase
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    FirebaseApp.configure()
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
