//
//  MemeCollectionViewController.swift
//  MemeMe-1.0
//
//  Created by Jacob Marttinen on 1/21/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit

// MARK: - MemeCollectionViewController: UICollectionViewController

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var memes: [Meme]!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Set up the Navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(MemeTableViewController.create)
        )
        self.navigationItem.title = "Sent Memes"
        
        // Set up the Collection View Flow Layout
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        memes = appDelegate.memes
        self.collectionView!.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Sent Memes"
        navigationItem.backBarButtonItem = backItem
    }
    
    
    // MARK: Collection View Data Source
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.memes.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MemeCollectionViewCell",
            for: indexPath
        ) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath:IndexPath
    ) {
        let detailController = self.storyboard!.instantiateViewController(
            withIdentifier: "MemeDetailViewController"
        ) as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    // MARK: Supplementary Functions
    
    // Displays the Create View
    func create() {
        let memeCreateVC = self.storyboard!.instantiateViewController(
            withIdentifier: "MemeCreateViewController"
        )
        self.present(memeCreateVC, animated: true, completion: nil)
    }
}
