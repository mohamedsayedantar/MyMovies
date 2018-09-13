//
//  TMDBAuthViewController.swift
//  moviesWithMVC
//
//  Created by Mohamed Sayed on 9/9/18.
//  Copyright © 2018 Mohamed Sayed. All rights reserved.
//

import Foundation
import UIKit

class TMDBAuthViewController: UIViewController {
    
    var urlRequest: URLRequest? = nil
    var requestToken: String? = nil
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        navigationItem.title = "TheMovieDB Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    @objc func cancelAuth() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TMDBAuthViewController: UIWebViewDelegate

extension TMDBAuthViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // if user has to login, this will redirect them back to the authorization url
        if webView.request!.url!.absoluteString.contains(TMDBClient.Constants.AccountURL) {
            if let urlRequest = urlRequest {
                webView.loadRequest(urlRequest)
            }
        }
        
        if webView.request!.url!.absoluteString == "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)/allow" {
            
            dismiss(animated: true) {
                self.completionHandlerForView!(true, nil)
            }
        }
    }
}
