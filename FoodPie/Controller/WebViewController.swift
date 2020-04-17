//
//  WebViewController.swift
//  FoodPie
//
//  Created by ciggo on 4/15/20.
//  Copyright © 2020 ciggo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!

    var targetUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never       

        if let url = URL(string: targetUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
