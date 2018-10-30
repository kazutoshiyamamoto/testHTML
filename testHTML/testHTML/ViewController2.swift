import UIKit
import WebKit

class ViewController2: UIViewController {
    
    var webView: WKWebView!
    var urlString = ""
    
    override func loadView() {
        super.loadView()
        self.createView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.uiDelegate = self
        
        self.contentsLoad()
        print("遷移できている")
        
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
    
    // URL読み込み
    func contentsLoad() {
        let url: URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url: url)
        self.webView.load(request)
    }
    
    // スワイプでリロードする
    // お知らせをリロードすると真っ白になる
    @objc func refreshWebView(sender: UIRefreshControl) {
        self.webView.reload()
        sender.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// target=_blankが設定されたページも開けるようにする
extension ViewController2: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
