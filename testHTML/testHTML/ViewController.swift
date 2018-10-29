import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var loadString: String = "<html><head><meta name=\"viewport\" content=\"width=device-width, user-scalable=no, shrink-to-fit=no\"></head><body>テスト</body></html>"
    
    override func loadView() {
        super.loadView()
        self.createView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        self.webView.loadHTMLString(loadString,baseURL: nil)
        
        // スワイプで画面遷移できるようにする
        self.webView.allowsBackForwardNavigationGestures = true
        
        // リフレッシュコントロールの設定
        let refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.webView.scrollView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(ViewController.refreshWebView(sender:)), for: .valueChanged)
        }
    }
    
    // Viewの作成
    func createView() {
        let rect = CGRect( x: 0, y: 0, width: self.view.frame.width,
                           height: self.view.frame.height)
        let viewConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: rect, configuration: viewConfiguration)
        
        view.addSubview(self.webView)
        view.sendSubviewToBack(self.webView)
    }
    
    // スワイプでリロードする
    @objc func refreshWebView(sender: UIRefreshControl) {
        self.webView.loadHTMLString(loadString,baseURL: nil)
        sender.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// target=_blankが設定されたページも開けるようにする
extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
