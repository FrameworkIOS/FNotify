//
//  ViewController.swift
//  FNotifyExample
//
//  Created by Apple on 09/01/22.
//

import UIKit
import FNotify

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showMessage(_ sender: Any) {
        
        let title = NSAttributedString(string: "ALERT", attributes: [.font:UIFont.systemFont(ofSize: 15)])
        
        let msg = NSMutableAttributedString(string: "", attributes: [.font:UIFont.systemFont(ofSize: 14)])
//        let attach = NSTextAttachment()
//        attach.image = UIImage(named:"plus")
        msg.append(NSAttributedString(string: "Hello I AM UNDER THE WATER"))
        
        FNotify(title: title, message: msg,position: .top)
            .show()
            .onDismiss { (message) in
                
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

