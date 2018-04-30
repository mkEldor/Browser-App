//
//  ViewController.swift
//  Browser-App
//
//  Created by Eldor Makkambaev on 01.05.2018.
//  Copyright © 2018 Eldor Makkambaev. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nameTextField: UITextField?
    var urlTextField: UITextField?
    var websites: [NSManagedObject] = []
    var favourites: [NSManagedObject] = []
    public static var page: Int = 0
    let s: String = "qwerty"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.page = 0
        MyDatabase.getAllWebsites(websites: &websites, favourites: &favourites)
        
    }
    @IBAction func switchTableViewAction(_ sender: UISegmentedControl) {
        ViewController.page = sender.selectedSegmentIndex
        MyDatabase.getAllWebsites(websites: &websites, favourites: &favourites)
        tableView.reloadData()
    }
    
    // Add button pressed (Alert)
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        createAlert()
    }
    func saveWebsite(action: UIAlertAction){
        if (!(nameTextField?.text?.isEmpty)! && !(urlTextField?.text?.isEmpty)!){
            MyDatabase.saveWebsite(websites: &websites, (nameTextField?.text)!, (urlTextField?.text)!, false)
            tableView.reloadData()
        }
    }
    
    //    TableView
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ViewController.page == 0{
            return websites.count
        } else {
            return favourites.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website_cell") as! WebsiteTableViewCell
        
        if ViewController.page == 0{
            let website = websites[indexPath.row]
            cell.nameLabel.text = website.value(forKey: "nameWebsite") as? String
            
        }
        else if ViewController.page == 1{
            let website = favourites[indexPath.row]
            cell.nameLabel.text = website.value(forKey: "nameWebsite") as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if ViewController.page == 0{
            MyDatabase.deleteWebsite(website: websites[indexPath.row])
            websites.remove(at: indexPath.row)
            
        } else {
            MyDatabase.update(websites: &websites, favourites: &favourites, indexPath: indexPath)
        }
        tableView.reloadData()
    }
    
    //    Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController {
            if let webController = navController.visibleViewController as? WebViewController {
                guard let indexPath = tableView.indexPathForSelectedRow else {return }
                var website: NSObject!
                if ViewController.page == 0{
                    website = websites[indexPath.row]
                }
                else if ViewController.page == 1{
                    website = favourites[indexPath.row]
                }
                webController.tableViewDelegate = self
                webController.url = website.value(forKey: "urlWebsite") as? String
                webController.myTitle = website.value(forKey: "nameWebsite") as? String
                webController.indexPath = tableView.indexPathForSelectedRow
            }
        }
    }
}

extension ViewController: TableViewDelegate {
    func createAlert(){
        let alertController = UIAlertController(title: "Adding website", message: "Fill all the fields", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: nameTextField)
        alertController.addTextField(configurationHandler: urlTextField)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: self.saveWebsite)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true)
    }
    
    func nameTextField(textField: UITextField) {
        nameTextField = textField
    }
    func urlTextField (textField: UITextField) {
        urlTextField = textField
    }
    func justDoIt() {
        MyDatabase.getAllWebsites(websites: &websites, favourites: &favourites)
        tableView.reloadData()
    }
}

