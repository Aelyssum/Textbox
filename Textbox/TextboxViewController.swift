//
//  TextboxViewController.swift
//  textbox
//
//  Created by Allan Evans on 12/6/16.
//  Copyright © 2016 Aelyssum Corp. All rights reserved.
//

import UIKit
import Textbox

protocol TextboxViewControllerDelegate {
    func textboxViewController(didSaveFrom textboxViewController: TextboxViewController)
    func textboxViewController(didCancelFrom textboxViewController: TextboxViewController)
    func textboxViewController(insertImageInto textboxViewController: TextboxViewController) -> UIImage
}


class TextboxViewController: UIViewController {
    
    var delegate: TextboxViewControllerDelegate?
    
    @IBOutlet var textboxView: TextboxView!
    @IBOutlet var toolbar:     UIToolbar!
    @IBOutlet var titleLabel:  UILabel!
    
    init(title: String, delegate: TextboxViewControllerDelegate) {
        self.titleLabel.text = title
        self.delegate = delegate
        let bundle = Bundle(identifier: "com.Aelyssum.Textbox")
        super.init(nibName: "TextboxViewController", bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSave() {
    
    }
    
    @IBAction func didCancel() {
        
    }
    
}
