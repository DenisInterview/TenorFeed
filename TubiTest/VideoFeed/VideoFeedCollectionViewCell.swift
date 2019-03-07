//
//  VideoFeedCollectionViewCell.swift
//  TubiTest
//
//  Created by Denis Kalashnikov on 2/16/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit
import SDWebImage


class VideoFeedCollectionViewCell: UICollectionViewCell {
    static let id = "VideoFeedCollectionViewCell"
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    
    func setup(_ model: VideoModel) {
        if let urlStr = model.media?.first?["tinygif"]?.url {
            let url = URL(string: urlStr)
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "image-placeholder"))
            
        }
    }
    
}
