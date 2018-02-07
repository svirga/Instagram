//
//  FeedViewController.swift
//  Instagram
//
//  Created by Simona Virga on 2/5/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let logoutAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to log out?", preferredStyle: .alert)
  var posts: [Post] = []
  var refreshControl: UIRefreshControl!
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.estimatedRowHeight = 300
    self.tableView.rowHeight = UITableViewAutomaticDimension
    
    let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
      NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
      // Do nothing; dismisses the view
    }
    logoutAlert.addAction(logoutAction)
    logoutAlert.addAction(cancelAction)
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.addTarget(self, action: #selector(getPosts), for: .valueChanged)
    self.tableView.addSubview(refreshControl)
    
    
    
    getPosts()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogOut(_ sender: Any) {
    present(logoutAlert, animated: true) {
      // If they tap Logout, the notificaiton will be sent to the app to log them out.
    }
  }
  
  @IBAction func onLogOutManual(_ sender: Any) {
    present(logoutAlert, animated: true) {
      // If they tap Logout, the notificaiton will be sent to the app to log them out.
    }
  }
  
  @objc func getPosts() {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      // Stop the refresh controller
      self.refreshControl.endRefreshing()
    }
    
    Post.getPosts(success: { (posts: [Post]) in
      self.posts = posts
      self.tableView.reloadData()
      print("RETRIEVING SUCCEDED!")
      print("Number of posts: \(posts.count)")
    }) { (error: Error?) in
      print("error: \(String(describing: error?.localizedDescription))")
      print("RETRIEVING FAILED")
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    
    cell.selectionStyle = .none
    
    let post = posts[indexPath.row]
    cell.post = post
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if segue.identifier == "detailSegue" {
      let cell = sender as! PostCell
      if tableView.indexPath(for: cell ) != nil {
        let post = cell.post
        let detailViewController = segue.destination as! PostDetailsViewController
        detailViewController.post = post
      }
    }
  }
  
  
}
