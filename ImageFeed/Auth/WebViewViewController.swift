import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: - UI and Lyfe Cycle
    
    private lazy var webView: WKWebView = {
        let element = WKWebView()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setupConstraints()
        
        if let url = URL(string: "https://www.ya.ru") {
                    webView.load(URLRequest(url: url))
                }
    }
    private func setView() {
        view.addSubview(webView)
    }
    
    // MARK: - Actions
    
}

// MARK: - Constraints

extension WebViewViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

