import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    // Bias toward a phone-like portrait ratio so the first screen fits on open.
    let aspect: CGFloat = 0.475

    let visibleFrame = NSScreen.main?.visibleFrame ?? self.frame
    let maxHeight = floor(visibleFrame.height * 0.985)
    let maxWidth = floor(visibleFrame.width * 0.64)

    var targetHeight = maxHeight
    var targetWidth = floor(targetHeight * aspect)

    if targetWidth > maxWidth {
      targetWidth = maxWidth
      targetHeight = floor(targetWidth / aspect)
    }

    targetWidth = max(targetWidth, 430)
    targetHeight = max(targetHeight, 920)

    let origin = NSPoint(
      x: visibleFrame.midX - targetWidth / 2,
      y: visibleFrame.midY - targetHeight / 2
    )
    let windowFrame = NSRect(origin: origin, size: NSSize(width: targetWidth, height: targetHeight))

    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
