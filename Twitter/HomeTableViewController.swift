//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Benjamin Garcia on 9/17/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    var darkModeToggled = false
    
    @IBOutlet weak var darkModeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.bool(forKey: "darkModeEnabled") == true) {
            enableDarkMode()
        } else {
            disableDarkMode()
        }
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        myRefreshControl.tintColor = UIColor.systemTeal
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadTweets()
    }
    
    @objc func loadTweets() {
        let timelineRequestUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        darkModeToggled = false
        numberOfTweets = 20
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: timelineRequestUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retreive tweets!")
        })
    }
    
    func loadMoreTweets() {
        let timelineRequestUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        darkModeToggled = false
        numberOfTweets += 20
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: timelineRequestUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not retreive tweets!")
        })
    }
    
    @IBAction func toggleDarkMode(_ sender: Any) {
        darkModeToggled = true
        if (UserDefaults.standard.bool(forKey: "darkModeEnabled") == false) {
            enableDarkMode()
        } else if (UserDefaults.standard.bool(forKey: "darkModeEnabled") == true) {
            disableDarkMode()
        } else {
            enableDarkMode()
        }
        tableView.reloadData()
    }
    
    func enableDarkMode() {
        UserDefaults.standard.set(true, forKey: "darkModeEnabled")
        tableView.backgroundColor = UIColor.black
        tableView.separatorColor = UIColor.white
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        if #available(iOS 13.0, *) {
            darkModeButton.image = UIImage(systemName: "moon.fill")
        } else {
            darkModeButton.title = "Light Mode"
        }
    }
    
    func disableDarkMode() {
        UserDefaults.standard.set(false, forKey: "darkModeEnabled")
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = nil
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.default
        if #available(iOS 13.0, *) {
            darkModeButton.image = UIImage(systemName: "moon")
        } else {
            darkModeButton.title = "Dark Mode"
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true) {
            print("Logged Out.")
        }
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        let imageUrl = URL(string: user["profile_image_url_https"] as! String)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.userNameLabel.text = user["name"] as! String
        let userTag = user["screen_name"] as! String
        cell.userNameTag.text = "@\(userTag)"
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as! String
        
        if (UserDefaults.standard.bool(forKey: "darkModeEnabled") == true) {
            cell.enableDarkMode()
        } else if (UserDefaults.standard.bool(forKey: "darkModeEnabled") == false) {
            cell.disableDarkMode()
        }
        
        if (!darkModeToggled) {
            cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
            cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)
            cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        }
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == tweetArray.count) {
            loadMoreTweets()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
