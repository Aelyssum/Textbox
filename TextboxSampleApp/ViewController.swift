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

    @IBOutlet var textBox:      TextboxView!
    @IBOutlet var html:         UITextView!
    @IBOutlet var saveButton:   UIButton!
    @IBOutlet var loadButton:   UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        html.text = "<H1>Foo</H1><p>The quick red fox jumped over the lazy brown dog</p>"
        saveButton.setTitle("Edit", for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
//        textBox.setEditText(html.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didLoad() {
        textBox.setEditText(html.text)
    }
    
    @IBAction func didSave() {
        NSLog("ViewController:didSave:  Executed")
        if saveButton.titleLabel!.text == "Edit" {
            textBox.isEnabled = true
            html.isEditable = true
            saveButton.setTitle("Done", for: .normal)
        } else {
            textBox.endEditing(false)
            html.endEditing(false)
            textBox.getEditText() {
                html, hasUpdates, error in
                if error == nil {
                    self.html.text = html
                } else {
                    NSLog("ViewController:didSave:  "+error!.localizedDescription)
                }
            }
            textBox.isEnabled = false
            html.isEditable = false
            saveButton.setTitle("Edit", for: .normal)
        }
    }
    

}

