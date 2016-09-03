//
//  ImageViewController.swift
//  smashTag
//
//  Created by Sam Wang on 8/31/16.
//  Copyright © 2016 Sam Wang. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            //rescale()
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    
    private var widthOfFram = UIScreen.mainScreen().bounds.width
    
    
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 2.0
        }
    }
    

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var viewDidScrollOrZoom = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        viewDidScrollOrZoom = true
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        viewDidScrollOrZoom = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Picture"
        scrollView.addSubview(imageView)
    }

}
