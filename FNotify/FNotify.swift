//
//  FNotify.swift
//  FNotify
//
//  Created by Krisna Pranav on 09/01/22.
//

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
    
    public init(title : NSAttributedString,
                message : NSAttributedString,
                duration: Double? = 3.0,
                position: Position = .top,
                status : Status = .success,
                config:FNMessageConfig = FNMessageConfig.shared) {
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.config = config
        self.title.attributedText = title
        self.message.attributedText = message
        self.status = status
        self.duration = duration
        self.position = position
        setup()
    }
    
    public convenience init(title : String,
                            message : String,
                            duration: Double? = 3.0,
                            position: Position = .top,
                            status : Status = .success,
                            config:FNMessageConfig = FNMessageConfig.shared) {
        
        let attrTitle = NSAttributedString(string: title, attributes: [.font:config.titleFont,.foregroundColor:config.titleColor])
        
        let attrMessage = NSAttributedString(string: message, attributes: [.font:config.messageFont,.foregroundColor:config.messageColor])
        self.init(title: attrTitle, message: attrMessage, duration: duration, position: position, status: status, config: config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        backgroundColor = UIColor.clear
        
        mainView.frame = bounds
        mainView.backgroundColor = UIColor.clear
        mainView.layer.addSublayer(mainShape)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leftAnchor.constraint(equalTo: leftAnchor),
            mainView.rightAnchor.constraint(equalTo: rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.widthAnchor.constraint(equalToConstant: min(400, UIScreen.main.bounds.width - 32)),
            ])
        
        
        iconView = UIImageView()
        iconView.contentMode = .center
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        mainView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            iconView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 8),
            iconView.topAnchor.constraint(equalTo: mainView.topAnchor),
            iconView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            ])
        
        title.numberOfLines = 0
        title.font = config.titleFont
        title.textColor = config.titleColor
        title.translatesAutoresizingMaskIntoConstraints = false
        title.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        title.setContentHuggingPriority(.required, for: .vertical)
        mainView.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            title.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 16),
            title.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16),
            ])
        
        message.numberOfLines = 0
        message.font = config.messageFont
        message.textColor = config.messageColor
        message.translatesAutoresizingMaskIntoConstraints = false
        message.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        mainView.addSubview(message)
        NSLayoutConstraint.activate([
            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            message.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 0),
            message.rightAnchor.constraint(equalTo: title.rightAnchor, constant: 0),
            message.bottomAnchor.constraint(equalTo: message.superview!.bottomAnchor, constant: -16),
            ])
        
        mainShape.fillColor = config.backgrounColors[status]?.cgColor
        iconView.image = config.images[status]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideMessages))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.onMoving(pan:)))
        addGestureRecognizer(pan)
        
        if let duration = duration {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hideMessages), userInfo: nil, repeats: false)
        }
    }
    
}


