import Foundation

extension ProcessInfo {
    var isPreviewEnabled: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
} 