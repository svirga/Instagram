//
//  Post.swift
//  Instagram
//
//  Created by Simona Virga on 2/5/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Post: NSObject {
  var media : PFFile
  var author: PFUser
  var caption: String?
  var likesCount: Int
  var commentsCount: Int
  var timestamp: String?
  
  init(pfObject: PFObject) {
    self.media = pfObject["media"] as! PFFile
    self.author = pfObject["author"] as! PFUser
    self.caption = pfObject["caption"] as? String
    self.likesCount = pfObject["likesCount"] as! Int
    self.commentsCount = pfObject["commentsCount"] as! Int
    self.timestamp = pfObject["timestamp"] as? String
  }
  
  /* Needed to implement PFSubclassing interface */
  class func parseClassName() -> String {
    return "Post"
  }
  
  /**
   * Other methods
   */
  
  /**
   Method to add a user post to Parse (uploading image file)
   
   - parameter image: Image that the user wants upload to parse
   - parameter caption: Caption text input by the user
   - parameter completion: Block to be executed after save operation is complete
   */
  class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
    // use subclass approach
    let post = PFObject(className: "Post")
    
    // Make sure image won't violate 10MB limit
    let image = resize(image: image!, newSize: CGSize(width: 612, height: 612))
    
    // Add relevant fields to the object
    post["media"] = getPFFileFromImage(image: image)! // PFFile column type
    post["author"] = PFUser.current()! // Pointer column type that points to PFUser
    post["caption"] = caption!
    post["likesCount"] = 0
    post["commentsCount"] = 0
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/YYYY"
    post["timestamp"] = formatter.string(from: Date())
    
    // Save object (following function will save the object in Parse asynchronously)
    post.saveInBackground(block: completion)
  }
  
  /**
   Method to convert UIImage to PFFile
   
   - parameter image: Image that the user wants to upload to parse
   
   - returns: PFFile for the the data in the image
   */
  class func getPFFileFromImage(image: UIImage?) -> PFFile? {
    // check if image is not nil
    if let image = image {
      // get image data and check if that is not nil
      if let imageData = UIImagePNGRepresentation(image) {
        return PFFile(name: "image.png", data: imageData)
      }
    }
    return nil
  }
  
  // Function to get next 20 posts
  class func getPosts(success: @escaping ([Post]) -> (), failure: @escaping (Error?) -> ()) {
    // construct PFQuery
    let query = PFQuery(className: "Post")
    query.order(byDescending: "createdAt")
    query.includeKey("author")
    query.limit = 20
    
    // fetch data asynchronously
    query.findObjectsInBackground { (pfObjects: [PFObject]?, error: Error?) -> Void in
      if let pfObjects = pfObjects {
        
        // Make posts array
        var posts: [Post] = []
        for pfObject in pfObjects {
          posts.append(Post(pfObject: pfObject))
        }
        
        // Send it back to the caller
        success(posts)
        
      } else {
        // handle error
        print("Error: \(String(describing: error?.localizedDescription))")
      }
    }
  }
  
  // Function to resize image
  class public func resize(image: UIImage, newSize: CGSize) -> UIImage {
    let resizeImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: newSize.width, height: newSize.height)))
    resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
    resizeImageView.image = image
    
    UIGraphicsBeginImageContext(resizeImageView.frame.size)
    resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
}

