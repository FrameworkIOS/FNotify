import UIKit

public class FNotify: UIView {
    override public func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8,height: 8))
        mainShape.frame = rect
        mainShape.path = path.cgPath
        mainShape.shadowColor = UIColor.black.cgColor
        mainShape.shadowOffset = CGSize(width: 1, height: 1)
        mainShape.shadowRadius = 15
        mainShape.shadowOpacity = 0.4
    }
    
    public enum Status : CaseIterable {
        case error
        case info
        case success
    }
    
    public enum Position {
        case top
        case bottom
    }
    
    public typealias FNcompleteHandler = (FNotify) -> Void
    
    private var topConstraint : NSLayoutConstraint?
    private var bottomConstraint : NSLayoutConstraint?
    
    private var message = UILabel()
    private var title = UILabel()
    private var action : FNcompleteHandler? = nil
    private var mainView = UIView()
    private var mainShape = CAShapeLayer()
    private var duration : Double?
    private var position : Position = .top
    private var iconView : UIImageView!
    private var timer : Timer? = nil
    private(set) var status : Status = .error
    private(set) var config : FNMessageConfig!
}
