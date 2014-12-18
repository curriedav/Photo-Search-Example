//
//  ViewController.swift
//  Photo Search Example Async
//
//  Created by David Currie on 12/18/14.
//  Copyright (c) 2014 Urban Airship. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let instagramClientID = "44b3919e7dbe4373a2aeb600363e561f"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInstagramByHashtag("KobyBeef")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchInstagramByHashtag(searchString: String) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        let instagramURLString = "https://api.instagram.com/v1/tags/" + searchString + "/media/recent?client_id=" + instagramClientID
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET(instagramURLString,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
                
                if let dataArray = responseObject.valueForKey("data") as? [AnyObject] {
                    self.scrollView.contentSize = CGSizeMake(320, CGFloat(320*dataArray.count))
                    for var i = 0; i < dataArray.count; i++ {
                        let dataObject: AnyObject = dataArray[i]
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            println("image " + String(i) + " URL is " + imageURLString)
                            
                            let imageView = UIImageView(frame: CGRectMake(0, CGFloat(320*i), 320, 320))
                            self.scrollView.addSubview(imageView)
                            imageView.setImageWithURL( NSURL(string: imageURLString))
                        }                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        searchBar.resignFirstResponder()
        
        searchInstagramByHashtag(searchBar.text)
    }
    
    
    
}