//
//  ViewController.swift
//  Orian
//
//  Created by Catalina19 on 10/02/21.
//

import UIKit
import WebKit
//Global Variables
var selectedIndex = 0;
var tabDetails = [[String:String]]()

class ViewController: UIViewController, WKNavigationDelegate,WKUIDelegate,UITextFieldDelegate {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tfsearch: UITextField!
    @IBOutlet weak var contianerView: UIView!
    @IBOutlet weak var newTabButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:- Variables
    
    var webViews : [WKWebView] = []
    var webView: WKWebView!
    
    //MARK:- View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: contianerView.frame.width, height: contianerView.frame.height))
        contianerView.addSubview(webView)
        let url = URL(string: "https://www.google.com")!
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
        webView.uiDelegate = self
    
        webView.allowsBackForwardNavigationGestures = true
        tfsearch.delegate = self;
        checkBottomBarObject()
        webViews.append(webView)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(newTab), name: Notification.Name("NewTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectTab), name: Notification.Name("SelectTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRemoveTab), name: Notification.Name("RemoveTab"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NewTab"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("SelectTab"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("RemoveTab"), object: nil)
    }
    
    //MARK:- Observer Methods
    
    @objc func newTab() {
        contianerView.subviews.forEach({ $0.removeFromSuperview() })
        selectedIndex = selectedIndex + 1;
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: contianerView.frame.width, height: contianerView.frame.height))
        contianerView.addSubview(webView)
        let url = URL(string: "https://www.apple.com")!
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webViews.append(webView)
      
        checkBottomBarObject()
    
    }
    
    @objc func onSelectTab() {
        contianerView.subviews.forEach({ $0.removeFromSuperview() })
        webView = webViews[selectedIndex];
        contianerView.addSubview(webView)
        webView.uiDelegate = self
        checkBottomBarObject()
        tfsearch.text = webView.url!.absoluteString;
    }
    @objc func onRemoveTab(notification: Notification){
        if let userInfo = notification.userInfo {
            let index = userInfo["index"] as! Int
            webViews.remove(at: index )
            print("webviews count",webViews.count)
        }
    
    }
    
    //MARK:- General Methods
    
    func checkBottomBarObject(){
        if(!webView.canGoBack){
            backButton.tintColor = .darkGray;
            backButton.isEnabled = false
        }else{
            backButton.tintColor = .systemBlue;
            backButton.isEnabled = true
        }
        if(!webView.canGoForward){
            nextButton.tintColor = .darkGray;
            nextButton.isEnabled = false
        }else
        {
            nextButton.tintColor = .systemBlue;
            nextButton.isEnabled = true
        }

    }
    

    
    func onSearchClick(text: String){
        var url : URL!;
        if ( text.isValidURL() ) {
            url = URL(string: text)!
        }else if ( text.contains(".") ){
            url = URL(string: "https://"+text)!
        }else{
            url = URL(string: "https://www.google.com/search?q="+text)!
        }
        webView.load(URLRequest(url: url))
    
    }
    
    //MARK:- Button Click Methods
    
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        webView.goBack();
        for page in webView.backForwardList.backList {
            print("User visited \(page)")
        
        }
    }
    
    @IBAction func onNextButtonClick(_ sender: Any) {
        webView.goForward();
    }
    @IBAction func onNewTabClick(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowTabViewController")
        self.present(vc, animated: true)
    }
    
    //MARK:- Webview Delegate Methods

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
       
        checkBottomBarObject()
        tfsearch.text = webView.url?.absoluteString
        let temp = ["title":webView.title!,"url":webView.url!.absoluteString];
        if(tabDetails.count == 0 || tabDetails.count - 1 < selectedIndex){
            tabDetails.append(temp);
        }else{
            tabDetails[selectedIndex] = temp;
        }
       
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let temp = ["title":webView.title!,"url":webView.url!.absoluteString];
        if(tabDetails.count == 0 || tabDetails.count - 1 < selectedIndex){
            tabDetails.append(temp);
        }else{
            tabDetails[selectedIndex] = temp;
        }
        
        print("Title ",webView.title!)
    }
    
    //MARK:- Textfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Textfield text\(textField.text!)")
        onSearchClick(text: textField.text!)
        self.view.endEditing(true)
              return false
    }
}

