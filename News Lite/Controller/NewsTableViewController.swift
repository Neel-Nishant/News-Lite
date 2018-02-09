//
//  NewsTableViewController.swift
//  News Lite
//
//  Created by Neel Nishant on 06/02/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit
import CoreData
class NewsTableViewController: UITableViewController {

    var articleData = [Article]()
    var sourceId = ""
    var selectedBackgroundColor = UIColor()
    var selectedTextColor = UIColor()
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        
    @IBAction func refreshNewsData(_ sender: UIRefreshControl) {
        for article in articleData {
            CoreDataStack.sharedInstance().context.delete(article as! NSManagedObject)
            do {
                try CoreDataStack.sharedInstance().saveContext()
            }
            catch {
                print("error deleting photos")
            }
        }
        getNewsData()
        do {
            articleData = (try CoreDataStack.sharedInstance().context.fetch(fr) as? [Article])!
            print("newsData")
            
        }
        catch {
            print("error in segue")
            return
        }
        
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
        sender.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityView.center = self.view.center
        self.view.addSubview(activityView)
//        let indexPath = tableView.indexPathForSelectedRow!
//        let source = Constants.Sources.sources[indexPath.row]
//        let sourceId = source["id"]
        let predicate = NSPredicate(format: "sourceId = %@", argumentArray: [sourceId])
        fr.predicate = predicate
        
        do {
            articleData = (try CoreDataStack.sharedInstance().context.fetch(fr) as? [Article])!
            print("newsData")
            
        }
        catch {
            print("error in segue")
            return
        }
        
        if articleData.isEmpty {
            performUIUpdatesOnMain {
                self.activityView.startAnimating()
                self.getNewsData()
                
            }
        }
        else {
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
            
//            performSegue(withIdentifier: "newsSegue", sender: nil)
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getNewsData(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.onPostsLoaded), name: NSNotification.Name(rawValue: "postsLoaded"), object: nil)
        NewsAPIClient.sharedInstance.taskForGETMethod(sourceId: sourceId) { (success, error) in
            if success {
                print("success")
                do {
                    self.articleData = (try CoreDataStack.sharedInstance().context.fetch(self.fr) as? [Article])!
//                    print("newsData:\(self.articleData)")
                    
                }
                catch {
                    print("error in segue")
                    return
                }
                do {
                    try CoreDataStack.sharedInstance().saveContext()
                }
                catch {
                    print("error deleting photos")
                }
                performUIUpdatesOnMain {
                    
                    self.tableView.reloadData()
                    self.activityView.stopAnimating()
                 
                }
                
            }
            else {
                performUIUpdatesOnMain {
                    self.createAlert(title: "Oops!!!!", message: error!)
                    self.activityView.stopAnimating()
                }
//                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !articleData.isEmpty {
            loadNews()
        }
        
    }
    @objc func onPostsLoaded(_ notif: AnyObject)
    {
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
            self.activityView.stopAnimating()
        }
    }
    
    func loadNews() {
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
    
    func createAlert(title: String, message: String){
    
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
                
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articleData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsData", for: indexPath) as! NewsTableViewCell
        cell.activityIndicator.hidesWhenStopped = true
        performUIUpdatesOnMain {
            cell.activityIndicator.startAnimating()
        }
        // Configure the cell...
        let article = articleData[indexPath.row]
        cell.newsLabel.text = article.title
        cell.backgroundColor = selectedBackgroundColor
        cell.newsLabel.textColor = selectedTextColor
//        cell.textLabel?.text = news.title
        print("article: \(article.title)")
        print("urlToImage: \(article.urlToImage?.count)")
        if (article.urlToImage?.count)! != 0 {

            if article.imageData == nil {
                NewsAPIClient.sharedInstance.getImageForCell(urlToImage: article.urlToImage!, completionHandler: { (cellImage) in

                    performUIUpdatesOnMain {
                        article.imageData = UIImagePNGRepresentation(cellImage) as! NSData
                        do {
                            try CoreDataStack.sharedInstance().saveContext()
                        }
                        catch {
                            print("error deleting photos")
                        }
//                        cell.configCell(article)
                        cell.newsImage.image = cellImage
                        cell.activityIndicator.stopAnimating()
                        //                        cell.imageView?.image = cellImage
                    }
                })
            }
            else {
                performUIUpdatesOnMain {
//                    cell.configCell(article)
                    cell.newsImage.image = article.image
                    cell.activityIndicator.stopAnimating()
//                    cell.imageView?.image = news.image
                }
            }

        }
        
        else {
                performUIUpdatesOnMain {
                    cell.widthOfImage.constant = 0
                    cell.activityIndicator.isHidden = true
                }
        }
//        print("sourceName = \(article.sourceName)")
//        print("title:\(article.title)")
//        print("desc:\(article.articleDescription)")
//        print("url:\(article.url)")
//        print("imageUrl:\(article.urlToImage)")
//        print("image:\(article.imageData)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "newsDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetail" {
            if let newsDetailVC = segue.destination as? NewsDetailViewController {
                let article = articleData[(tableView.indexPathForSelectedRow?.row)!]
                if (article.image != nil) {
                    newsDetailVC.newsImageData = article.image!
                }
                else {
                    
                }
                newsDetailVC.newsTitleString = article.title!
                newsDetailVC.newsDescriptionString = article.articleDescription!
                newsDetailVC.newsUrl = article.url!
                newsDetailVC.selectedBackgroundColor = selectedBackgroundColor
                newsDetailVC.selectedTextColor = selectedTextColor
            }
            
        }
        
    }

}

