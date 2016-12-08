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
        self.editText = editText
        webView.evaluateJavaScript("document.getElementById('textbox').value = \"\(editText)\";")
    }
    
    public func getEditText(completion: @escaping (_ text: String?, _ error: Error?)->()) {
        webView.evaluateJavaScript("getEditorContent()") {
            result, _error in
            if let error = _error {
                completion(nil, error)
            } else if let text = result as? String {
                self.editText = text
                completion(text, nil)
            } else {
                
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
