//
//  MyDB.swift
//  Browser-App
//
//  Created by Eldor Makkambaev on 01.05.2018.
//  Copyright © 2018 Eldor Makkambaev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MyDatabase {
    static func getAllWebsites (websites:  inout [NSManagedObject], favourites: inout [NSManagedObject]){
        favourites = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requestForList = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        requestForList.returnsObjectsAsFaults = false
        do {
            websites = try context.fetch(requestForList) as! [NSManagedObject]
        }
        catch {
            print("some errors")
        }
        for website in websites {
            let isFavourite = website.value(forKey: "isFavourite") as! Bool
            if isFavourite {
                favourites.append(website)
            }
        }
    }
    
    static func saveWebsite (websites:  inout [NSManagedObject], _ websiteName: String, _ websiteUrl: String, _ isFavourite: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newWebsite = NSEntityDescription.insertNewObject(forEntityName: "List", into: context)
        
        newWebsite.setValue(isFavourite, forKey: "isFavourite")
        newWebsite.setValue(websiteName, forKey: "nameWebsite")
        newWebsite.setValue(websiteUrl, forKey: "urlWebsite")
        
        do {
            try context.save()
            websites.append(newWebsite)
            print("Saved website: \(websiteName)")
        } catch {
            print("\(websiteName) wasn't  saved")
        }
    }
    static func deleteWebsite(website: NSManagedObject){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(website)
        do {
            try context.save()
        } catch {
            print("some error")
        }
    }
    static func update(websites:  inout [NSManagedObject], favourites: inout [NSManagedObject], indexPath: IndexPath){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let website = favourites[indexPath.row]
        website.setValue(false, forKey: "isFavourite")
        do {
            try context.save()
        } catch {
            print("some error")
        }
        favourites.remove(at: indexPath.row)
    }
    static func update1(websites:  inout [NSManagedObject], favourites: inout [NSManagedObject], url: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var website: NSManagedObject?
        for site in websites {
            let siteUrl = site.value(forKey: "urlWebsite") as! String
            if siteUrl == url{
                website = site
                break
            }
        }
        let isFav = website!.value(forKey: "isFavourite") as? Bool
        let isFavourite: Bool!
        if isFav!{
            isFavourite = false
            
        } else {
            isFavourite = true
        }
        website!.setValue(isFavourite, forKey: "isFavourite")
        do {
            try context.save()
        } catch {
            print("some error")
        }
    }
}

