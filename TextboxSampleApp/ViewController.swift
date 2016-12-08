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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func didSave() {
        textBox.getEditText() {
            result, error in
            if error == nil {
                self.html.text = result
            } else {
                NSLog(error!.localizedDescription)
            }
        }
    }
    

}
