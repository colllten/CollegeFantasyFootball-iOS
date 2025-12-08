import Foundation

@Observable
public class BaseViewModelV2 {
    // View-related
    var showAlert = false
    var alertMessage = ""
    
    // Retrieve season from UD for querying database
    let season = UserDefaults.standard.integer(forKey: "season")
    
    // Prints messages to preview console if true;
    // Used for debugging
    private static let previewPrinting = false
    
    public static func previewPrint(_ message: String) {
        if previewPrinting {
            print(message)
        }
    }
}
