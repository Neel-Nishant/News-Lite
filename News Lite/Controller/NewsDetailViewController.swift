//
//  NewsDetailViewController.swift
//  News Lite
//
//  Created by Neel Nishant on 06/02/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    var newsTitleString = ""
    var newsDescriptionString = ""
    var newsImageData: UIImage?
    var newsUrl = ""
    var selectedBackgroundColor = UIColor()
    var selectedTextColor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = selectedBackgroundColor
        newsTitle.textColor = selectedTextColor
        newsDescription.textColor = selectedTextColor
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        newsDescription.text = newsDescriptionString
        newsTitle.text = newsTitleString
        print("newsimageData:\(newsImageData)")
        if newsImageData != nil {
            newsImage.image = newsImageData
            newsImage.clipsToBounds = true
        }
        else {
            imageHeight.constant = 0
        }
        
    }
    
    @IBAction func openArticle(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: newsUrl)!, options: [:], completionHandler: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
