//
//  MemeCollectionViewController.swift
//  MemeMe-1.0
//
//  Created by Jacob Marttinen on 1/21/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MemeCollectionViewController: UICollectionViewController

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var memes: [Meme]!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MemeCollectionViewController.create))
        
        let space: CGFloat = 3.0
        let itemWidth = (self.view.frame.size.width - (2 * space)) / 3.0
        //let itemHeight = (self.view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func create() {
        let memeCreateVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeCreateViewController")as! MemeCreateViewController
        self.present(memeCreateVC, animated: true, completion: nil)
    }
}
