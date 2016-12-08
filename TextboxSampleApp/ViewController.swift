//
//  ViewController.swift
//  TextboxSampleApp
//
//  Created by Allan Evans on 12/7/16.
//  Copyright © 2016 Aelyssum Corp. All rights reserved.
//

import UIKit
import Textbox

class ViewController: UIViewController {

    @IBOutlet var textBox: TextboxView!
    @IBOutlet var html:    UITextView!
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.setEditText("<H1>Foo</H1><p>The quick red fox jumped over the lazy brown dog</p>")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func didSave() {
        NSLog("ViewController:didSave:  Executed")
        textBox.getEditText() {
            result, error in
            if error == nil {
                self.html.text = result
            } else {
                NSLog("ViewController:didSave:  "+error!.localizedDescription)
            }
        }
    }
    

}

