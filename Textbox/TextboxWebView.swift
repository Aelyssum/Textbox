//
//  TextboxWebView.swift
//  Textbox
//
//  Created by Allan Evans on 12/12/16.
//  Copyright © 2016 Aelyssum Corp. All rights reserved.
//

import Foundation
import WebKit

class TextboxWebView: WKWebView {
    
    init(frame: CGRect) {
        super.init(frame: frame, configuration: TextboxWebView.config())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        navigationDelegate = self
        let bundle = Bundle(identifier: "com.Aelyssum.Textbox")!
        let textboxHTMLURL = bundle.path(forResource: "textboxio", ofType: "html", inDirectory: "TextboxIO-Resources")!
        let baseURL = bundle.bundleURL.appendingPathComponent("TextboxIO-Resources", isDirectory: true)
        do {
            let textboxHTMLString = try String(contentsOfFile: textboxHTMLURL, encoding: String.Encoding.utf8)
            loadHTMLString(textboxHTMLString, baseURL: baseURL)
        } catch {
            assertionFailure("Failed to initialize textboxio.html")
        }
    }
    
    class func config() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        return configuration
    }
    
    fileprivate var editText: String = ""
    var isEnabled = false
    var isEditing = false
    
    public func setEditText(_ editText: String) {
        self.editText = editText
        if isEditing {
            evaluateJavaScript("setEditorContent(\"\(editText)\")")
        } else {
            evaluateJavaScript("document.body.innerHTML=\"\(editText)\";")
        }
    }
    
    public func getEditText(completion: @escaping (_ text: String?, _ hasUpdates: Bool?, _ error: Error?)->()) {
        NSLog("TextboxWebView:getEditText: Executed")
        if isEditing {
            evaluateJavaScript("getEditorContent()") {
                result, _error in
                if let error = _error {
                    NSLog("TextboxWebView:getEditText:evaluateJavaScript: \(error.localizedDescription)")
                    print("Result: \n\(result)")
                    completion(nil, nil, error)
                } else if let json = result as? [String: Any] {
                    self.editText = json["html"] as? String ?? ""
                    let hasUpdates = json["hasUpdates"] as! Bool
                    completion(self.editText, hasUpdates, nil)
                } else {
                    NSLog("TextboxWebView:getEditText:evaluateJavaScript:  Unable to parse return value")
                }
            }
        } else {
            completion(self.editText, nil, nil)
        }
        endEditing(true)
        isEditing = false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        NSLog("TextboxWebView:hitTest: Executed")
        if isEnabled && !isEditing {
            NSLog("TextboxWebView:hitTest: isEnabled && !isEditing")
            isEditing = true
            evaluateJavaScript("enableEditing();")
        }
        return super.hitTest(point, with: event)
    }
    
    // MARK: - UIResponder protocol overrides
    
    public override var canBecomeFirstResponder: Bool {
        NSLog("TextboxWebView:canBecomeFirstResponder: Executed")
        return isEnabled
    }
    
    public override func becomeFirstResponder() -> Bool {
        NSLog("TextboxWebView:becomeFirstResponder: Executed")
        if isEnabled {
            evaluateJavaScript("enableEditing();")
        }
        return true
    }
    
    public override func resignFirstResponder() -> Bool {
        NSLog("TextboxWebView:resignFirstResponder: Executed")
        evaluateJavaScript("disableEditing();")
        return super.resignFirstResponder()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("TextboxWebView:touchesBegan: Executed")
        super.touchesBegan(touches, with: event)
    }

    
}

extension TextboxWebView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        evaluateJavaScript("document.body.innerHTML=\"\(self.editText)\"")
    }
}
