//
//  ViewController.swift
//  phpicker
//
//  Created by Takahiro Tominaga on 2022/03/11.
//

import Foundation
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        askPermission()
    }
    
    func askPermission() {
        
        PHPhotoLibrary.requestAuthorization({(status) in
            
            if status == PHAuthorizationStatus.authorized {
                
                DispatchQueue.main.async {
                    
                }
            } else {
                
                print("No access")
            }
        })
    }
}
