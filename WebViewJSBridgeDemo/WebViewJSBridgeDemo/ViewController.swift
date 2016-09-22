//
//  ViewController.swift
//  WebViewJSBridgeDemo
//
//  Created by 王中尧 on 16/9/22.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

import WebViewJavascriptBridge

class ViewController: UIViewController, UIWebViewDelegate {
    
    var bridge : WebViewJavascriptBridge = WebViewJavascriptBridge()
    
    @IBOutlet weak var webView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载网页
        loadWebView()
        
        // 开启日志
        WebViewJavascriptBridge.enableLogging()
        
        // 给webView建立JS和Swift的沟通桥梁
        bridge = WebViewJavascriptBridge(forWebView: self.webView)
        bridge.setWebViewDelegate(self)
        
        // JS调用Swift的API:访问相册
        callOnImagePicker()
        
        // JS调用Swift的API:访问底部弹窗
        callAlert()
    }
    
    // MARK: - 调用Swift的API 访问相册
    private func callOnImagePicker() {
        bridge.registerHandler("openCamera") { (data : AnyObject?, responseCallback : WVJBResponseCallback?) in
            let imageVc : UIImagePickerController = UIImagePickerController()
            imageVc.sourceType = .PhotoLibrary
            self.presentViewController(imageVc, animated: true, completion: nil)
        }
    }
    
    // MARK: - 调用Swift的API 访问底部弹窗 alert
    private func callAlert() {
        bridge.registerHandler("showSheet") { (data : AnyObject?, responseCallback : WVJBResponseCallback?) in
            let alertVc : UIAlertController = UIAlertController(title: "我是Swift弹窗", message: "我真的是Swift弹窗啊啊啊啊！！！", preferredStyle: .ActionSheet)
            let cancelAction : UIAlertAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let okAction : UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertVc.addAction(cancelAction)
            alertVc.addAction(okAction)
            self.presentViewController(alertVc, animated: true, completion: nil)
        }
    }
    
    // MARK: - 加载网页
    private func loadWebView() {
        let indexPath : String! = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let appHtml : String! = try? NSString(contentsOfFile: indexPath, encoding: NSUTF8StringEncoding) as String
        let baseUrl = NSURL(fileURLWithPath: indexPath)
        webView.loadHTMLString(appHtml, baseURL: baseUrl)
    }

}

// MARK: - 界面点击事件
extension ViewController {
    
    // MARK: - 获取用户信息
    @IBAction func getUserInfo() {
        
        bridge.callHandler("getUserInfo", data: nil) { (data : AnyObject?) in
            
            let responseData = data as! NSDictionary
//            let responseData : Dictionary = data
            // 这里是NSDictionary，但是写法并不是 @"XXX" ？？
            let userInfo : String = "用户编号：\(responseData["userID"]!)，姓名：\(responseData["userName"]!)，年龄：\(responseData["age"]!)"
            let alertVc : UIAlertController = UIAlertController(title: "从网页端获取用户信息", message: userInfo, preferredStyle: .Alert)
            let cancelAction : UIAlertAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let okAction : UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertVc.addAction(cancelAction)
            alertVc.addAction(okAction)
            self.presentViewController(alertVc, animated: true, completion: nil)
        }
    }
    
    // MARK: - 弹窗
    @IBAction func showInfo() {
        
        bridge.callHandler("alertMessage", data: "调用了JS弹窗") { (responseData : AnyObject?) in
            
        }
    }
    
    // MARK: - 插入一张图片
    @IBAction func insertImgToWebView() {
        
        let dict : [String : String] = ["url" : "https://raw.githubusercontent.com/CoderZYWang/WebViewJSBridgeDemoForSwift/master/wzy.jpg"]
        bridge.callHandler("insertImgToWebView", data: dict) { (responseData : AnyObject?) in
            
        }
    }
    
    // MARK: - Reload
    @IBAction func reload() {
        
        webView.reload()
    }
    
    // MARK: - 界面跳转
    @IBAction func pushToNewWebView() {
        
        bridge.callHandler("pushToNewWebView", data: ["url" : "http://m.jd.com"]) { (responseData : AnyObject?) in
            
        }
    }
    
    @IBAction func popMainView() {
        
        bridge.callHandler("popMainView", data: ["url" : ""]) { (responseData : AnyObject?) in
            
        }
    }
    
}

