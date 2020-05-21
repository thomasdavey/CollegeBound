import Foundation
import UIKit

class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 5
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height += height
        }
        return sizeThatFits
    }
}
