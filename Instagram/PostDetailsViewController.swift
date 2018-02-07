//
//  PostDetailsViewController.swift
//  Instagram
//
//  Created by Simona Virga on 2/5/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostDetailsViewController: UIViewController
{
  
  @IBOutlet weak var postImageView: PFImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var captionLabel: UILabel!
  
  
  var post: Post!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    if (post) != nil {
      self.postImageView.file = self.post.media
      self.postImageView.loadInBackground()
      self.usernameLabel.text = self.post.author.username
      self.captionLabel.text = self.post.caption
      self.timestampLabel.text = self.post.timestamp
    }
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
