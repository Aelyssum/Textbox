//
//  TextboxView.swift
//  textbox
//
//  Created by Allan Evans on 12/6/16.
//  Copyright © 2016 Aelyssum Corp. All rights reserved.
//

import Foundation
//import WebKit

public class TextboxView: UIView {
    
    private var webView: TextboxWebView!
    
    public var isEnabled: Bool {
        set(newValue) {
            webView.isEnabled = newValue
        }
        get {
            return webView.isEnabled
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initWebView(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWebView(frame: self.frame)
    }
    
    func initWebView(frame: CGRect) {
        webView = TextboxWebView(frame: frame)
        self.isUserInteractionEnabled = true
        webView.isUserInteractionEnabled = true
        insertSubview(webView, at: 0)
    }
        
    public func setEditText(_ editText: String) {
        webView.setEditText(editText)
    }
    
    public func getEditText(completion: @escaping (_ text: String?, _ hasUpdates: Bool?, _ error: Error?)->()) {
        NSLog("TextboxView:getEditText: Executed")
        webView.getEditText(completion: completion)
    }

}
