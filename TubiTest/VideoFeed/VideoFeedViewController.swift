//
//  VideoFeedViewController.swift
//  TubiTest
//
//  Created by Denis Kalashnikov on 2/16/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import UIKit


class VideoFeedViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = VideoFeedModel()
    var searchText = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    let spacing = CGFloat(16)
    var numberOfItemsInRow = CGFloat(2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        refresh()
        
        let refereshControlView = UIRefreshControl()
        refereshControlView.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refereshControlView
        collectionView.refreshControl?.layer.zPosition = -3
   
        // Setup search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.setValue("Cancel", forKey: "_cancelButtonText")
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.definesPresentationContext = true
        
        
        //collection view layout
        collectionView.contentInset = UIEdgeInsets.init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
        }
    }
    
    @objc func refresh() {
        collectionView.refreshControl?.beginRefreshing()
        model.search(searchText) { error in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension VideoFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return model.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoFeedCollectionViewCell.id, for: indexPath) as! VideoFeedCollectionViewCell
        cell.setup(model.videos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(model.shouldLoadNextPage(indexPath.item)){
            model.loadNextPage { error in
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlStr = model.videos[indexPath.item].media?.first?["mp4"]?.url, let url = URL(string: urlStr) {
            let videoDetailViewController = UIStoryboard(name: "VideoDetailViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
            videoDetailViewController.videoURL = url
        navigationController?.pushViewController(videoDetailViewController, animated: true)
        }
    }
}

extension VideoFeedViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(self.view.frame.size.width > self.view.frame.size.height){ // landscape
            numberOfItemsInRow = (UIDevice.current.userInterfaceIdiom == .phone) ? CGFloat(3) : CGFloat(6)
        }else{
            numberOfItemsInRow = (UIDevice.current.userInterfaceIdiom == .phone) ? CGFloat(2) : CGFloat(4)
        }
    
        var width = (self.collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right)
        
        if let layoutCV = collectionViewLayout as? UICollectionViewFlowLayout{
            width = width - (layoutCV.minimumInteritemSpacing) * (numberOfItemsInRow - 1)
        }
        width /= numberOfItemsInRow
        let height = 150.0 / 200.0 * width
        return CGSize(width: width, height: height)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView.collectionViewLayout.invalidateLayout()

    }
}
extension VideoFeedViewController: UISearchBarDelegate{
    func filterContentForSearchText(_ searchText: String){
        self.searchText = searchText
        model.search(searchText) { (error) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text ?? ""
        refresh()
    }
}

extension VideoFeedViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    
}
