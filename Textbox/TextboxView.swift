//
//  TextboxView.swift
//  textbox
//
//  Created by Allan Evans on 12/6/16.
//  Copyright © 2016 Aelyssum Corp. All rights reserved.
//

import Foundation
import WebKit

public protocol TextboxDelegate {
    func textbox(insertImageInto textbox: TextboxView) -> UIImage
}

public class TextboxView: UIView {
    
    public var isEnabled = false {
        didSet(newValue) {
            NSLog("TextboxView:isEnabled:didSet: Executed")
            if newValue {
                webView.evaluateJavaScript("instantiateTextbox()")
            }
        }
    }
    
    private var webView: WKWebView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initWebView(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWebView(frame: self.frame)
    }
    
    func initWebView(frame: CGRect) {
        let configuration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        let controller = WKUserContentController()
        let bundle = Bundle(identifier: "com.Aelyssum.Textbox")!
//        let urlTextboxJS = bundle.path(forResource: "textboxio", ofType: "js", inDirectory: "TextboxIO- Resources/textboxio")!
//        do {
//            let textboxString = try String(contentsOfFile: urlTextboxJS, encoding:String.Encoding.utf8)
//            let textboxJS = WKUserScript(source: textboxString, injectionTime: .atDocumentStart, forMainFrameOnly: true)
//            controller.addUserScript(textboxJS)
//        } catch {
//            assertionFailure("Failed to initialize textboxio.js")
//        }
        configuration.userContentController = controller
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height),
                            configuration: configuration)
        webView.allowsBackForwardNavigationGestures = false
        let textboxHTMLURL = bundle.path(forResource: "textboxio", ofType: "html", inDirectory: "TextboxIO-Resources")!
        let baseURL = bundle.bundleURL.appendingPathComponent("TextboxIO-Resources", isDirectory: true)
        do {
            let textboxHTMLString = try String(contentsOfFile: textboxHTMLURL, encoding: String.Encoding.utf8)
            webView.loadHTMLString(textboxHTMLString, baseURL: baseURL)
        } catch {
            assertionFailure("Failed to initialize textboxio.html")
        }
        insertSubview(webView, at: 0)
    }
    
    public var delegate: TextboxDelegate?
    private var editText: String = ""
    
    public func setEditText(_ editText: String) {
        NSLog("TextboxView:setEditText:  Executed")
        self.editText = editText
        webView.evaluateJavaScript("setEditorContent(\"\(editText)\")")
    }
    
    public func getEditText(completion: @escaping (_ text: String?, _ hasUpdates: Bool?, _ error: Error?)->()) {
        NSLog("TextboxView:getEditText:  Executed")
        webView.evaluateJavaScript("getEditorContent()") {
            result, _error in
            if let error = _error {
                completion(nil, nil, error)
            } else if let json = result as? [String: Any] {
                self.editText = json["html"] as? String ?? ""
                let hasUpdates = json["hasUpdates"] as! Bool
                completion(self.editText, hasUpdates, nil)
            } else {
                NSLog("Unable to parse return value")
            }
        }
    }
    
    // MARK:  UIResponder methods
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("TextboxView:touchesBegan:  Executed")
        if isEnabled {
            webView.becomeFirstResponder()
//            webView.evaluateJavaScript("enableEditing(true)")
            webView.evaluateJavaScript("instantiateTextbox()")
        }
        super.touchesBegan(touches, with: event)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    

}
