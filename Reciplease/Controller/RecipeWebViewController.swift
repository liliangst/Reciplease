//
//  RecipeWebViewController.swift
//  Reciplease
//
//  Created by Lilian Grasset on 26/07/2023.
//

import UIKit
import WebKit

class RecipeWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: RecipesRepository.shared.selectedRecipe!.url)!
        webView.load(URLRequest(url: url))
        webView.isInspectable = true
    }

    @IBAction func tapBackToReciplease() {
        dismiss(animated: true)
    }
}
