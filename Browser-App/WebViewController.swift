//
//  WebViewController.swift
//  Browser-App
//
//  Created by Eldor Makkambaev on 01.05.2018.
//  Copyright © 2018 Eldor Makkambaev. All rights reserved.
//

import UIKit
import CoreData
import WebKit

protocol TableViewDelegate {
    func justDoIt()
}

class WebViewController: UIViewController, UIWebViewDelegate, UISearchBarDelegate {
    let searchBar = UISearchBar()
    var myTitle : String?
    var url : String?
    var indexPath: IndexPath?
    
    var tableViewDelegate: TableViewDelegate?
    
    var favourites: [NSManagedObject] = []
    var websites: [NSManagedObject] = []
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyDatabase.getAllWebsites(websites: &websites, favourites: &favourites)
        print(1)
        
        if let nonOptionalString = url {
            if nonOptionalString.hasPrefix("http") && !nonOptionalString.contains(" "){
                if let nonOptionalUrl = URL(string: nonOptionalString){
                    print(2)
                    
                    webView.load(URLRequest(url: nonOptionalUrl))
                    for web in favourites {
                        let name = web.value(forKeyPath: "nameWebsite") as! String
                        if name == myTitle!{
                            view.backgroundColor = UIColor.yellow
                        }
                    }
                }
            }
            
        }
        print(6)
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        print(webView.request!.url!.absoluteString)
    }
    //     SAVE
    @IBAction func addToFavourite(_ sender: UITapGestureRecognizer) {
        print("add to favourite pressed")
        if let _ = indexPath {
            MyDatabase.update1(websites: &websites, favourites: &favourites, url: url!)
            tableViewDelegate?.justDoIt()
            if view.backgroundColor == UIColor.yellow{
                view.backgroundColor = UIColor.white
            } else if view.backgroundColor == UIColor.white {
                view.backgroundColor = UIColor.yellow
            }
        }
        
    }
    //    SEARCH
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        creatSearchBar()
    }
    func creatSearchBar(){
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter your search here"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        print(searchBar.text!)
        let googleUrl = "https://www.google.kz/search?q=\(searchBar.text!)&oq=sad%20sa%20sa&aqs=chrome..69i57.1444j0j7&sourceid=chrome&ie=UTF-8"
        print(googleUrl)
        if let nonOptionalUrl = URL(string: googleUrl){
            webView.load(URLRequest(url: nonOptionalUrl))
        }
    }
}
