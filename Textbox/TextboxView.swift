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
    
    private var webView: WKWebView!
    
    public var isEnabled = false {
        willSet(newValue) {
            if !isEnabled && newValue {
                webView.evaluateJavaScript("instantiateTextbox()")
            }
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
        let configuration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        let controller = WKUserContentController()
        let bundle = Bundle(identifier: "com.Aelyssum.Textbox")!
        configuration.userContentController = controller
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height),
                            configuration: configuration)
        webView.allowsBackForwardNavigationGestures = false
        webView.navigationDelegate = self
        let textboxHTMLURL = bundle.path(forResource: "textboxio", ofType: "html", inDirectory: "TextboxIO-Resources")!
        let baseURL = bundle.bundleURL.appendingPathComponent("TextboxIO-Resources", isDirectory: true)
        do {
            let textboxHTMLString = try String(contentsOfFile: textboxHTMLURL, encoding: String.Encoding.utf8)
            webView.loadHTMLString(textboxHTMLString, baseURL: baseURL)
            webView.evaluateJavaScript("document.body.innerHTML=\"\(editText)\"")
        } catch {
            assertionFailure("Failed to initialize textboxio.html")
        }
        insertSubview(webView, at: 0)
    }
    
    public var delegate: TextboxDelegate?
    fileprivate var editText: String = ""
    
    public func setEditText(_ editText: String) {
        self.editText = editText
        if isEnabled {
            webView.evaluateJavaScript("setEditorContent(\"\(editText)\")")
        } else {
            webView.evaluateJavaScript("document.body.innerHTML=\"\(editText)\";")
        }
    }
    
    public func getEditText(completion: @escaping (_ text: String?, _ hasUpdates: Bool?, _ error: Error?)->()) {
        NSLog("TextboxView:getEditText: Executed")
        webView.endEditing(true)
        isEnabled = false
        webView.evaluateJavaScript("getEditorContent()") {
            result, _error in
            if let error = _error {
                NSLog("TextboxView:getEditText:evaluateJavaScript: \(error.localizedDescription)")
                completion(nil, nil, error)
            } else if let json = result as? [String: Any] {
                self.editText = json["html"] as? String ?? ""
                let hasUpdates = json["hasUpdates"] as! Bool
                completion(self.editText, hasUpdates, nil)
            } else {
                NSLog("TextboxView:getEditText:evaluateJavaScript:  Unable to parse return value")
            }
        }
    }
    
    func setTemplate(html: URL) {
        
    }
    
    func setTemplate(css: URL) {
        
    }
    
    func allows(imageInsertion: Bool) {
        
    }

}

extension TextboxView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML=\"\(self.editText)\"")
    }
}
