//
//  ViewController.swift
//  News
//
//  Created by MacBook on 7/3/19.
//  Copyright © 2019 Shakhboz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SafariServices

class ViewController: UITableViewController {
    
    let reachability = try! Reachability()
    
    let cellId = "cellId"
    
    var titleArray = [String]()
    var newsDescriptionArray = [String]()
    var imageURLArray = [String]()
    var newsStoryUrlArray = [String]()
    let pubDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponent()
        setupNavigationBarStyles()
        rechability()
    }
    
    func configureViewComponent() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = #colorLiteral(red: 0.1175108925, green: 0.1179169938, blue: 0.1214107946, alpha: 1)
        tableView.separatorColor = UIColor(white: 1, alpha: 0.2)
        navigationItem.title = "News"
        tableView.reloadData()
        
        view.addSubview(connectionLostTitle)
        connectionLostTitle.centerInSuperview()
    }
    
    func setupNavigationBarStyles() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.301928699, green: 0.3019839227, blue: 0.3019169569, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func rechability() {
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.connectionLostTitle.text = "No Network Connection"
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged , object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("Could not start notifier:\(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNewsData { (success) in
            if success {
                print("success")
                self.tableView.reloadData()
                print(self.imageURLArray.count)
            } else {
                print("Failed")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageURLArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? NewsCell else { return UITableViewCell() }
        
        var titles = String()
        var descriptions = String()
        
        if titleArray.count > 0 {
            titles = titleArray[indexPath.row]
        } else {
            titles = ""
        }
        
        if newsDescriptionArray.count > 0 {
            descriptions = newsDescriptionArray[indexPath.row]
        } else {
            descriptions = ""
        }
        
        if imageURLArray.count > 0 {
            
            cell.newsImage.sd_setImage(with: URL(string: imageURLArray[indexPath.row])) { (image, error, cache, urls) in
                if (error != nil) {
                    cell.newsImage.image = UIImage(named: "newsPlaceholder")
                } else {
                    cell.newsImage.image = image
                }
            }
        } else {
            cell.newsImage.image = UIImage(named: "newsPlaceholder")!
        }
        
        cell.newsImage.layer.cornerRadius = 10
        cell.configureCell(newsTitle: titles, newsDescription: descriptions)
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM dd, YYYY"
        cell.dateLabel.text = dateFormater.string(from: pubDate)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let urls = newsStoryUrlArray[(indexPath?.row)!]
        
        guard let url = URL(string: urls) else { return }
        let savariVC = SFSafariViewController(url: url)
        present(savariVC, animated: true)
    }
    
    private let connectionLostTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    @objc func internetChanged(note:Notification)  {
        let reachability  = note.object as! Reachability
        
        if reachability.connection != .none {
        } else {
            DispatchQueue.main.async {
                
            }
        }
    }
}

extension ViewController {
    
    func getNewsData(complete: @escaping (_ status: Bool) -> ()) {
        Alamofire.request("https://newsapi.org/v2/everything?q=android&from=2019-04-00&sortBy=publishedAt&apiKey=26eddb253e7840f988aec61f2ece2907&page=3", method: .get).responseJSON { (response) in
            
            guard let value = response.result.value else { return }
            
            let json = JSON(value)
            
            for item in json["articles"].arrayValue {
                self.titleArray.append(item["title"].stringValue)
                self.newsDescriptionArray.append(item["description"].stringValue)
                self.imageURLArray.append(item["urlToImage"].stringValue)
                self.newsStoryUrlArray.append(item["url"].stringValue)
            }
            complete(true)
        }
    }
}
