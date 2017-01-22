//
//  MemeTableViewController.swift
//  MemeMe-1.0
//
//  Created by Jacob Marttinen on 1/21/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit

// MARK: - MemeTableViewController: UITableViewController

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var memes: [Meme]!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Set up the Navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(MemeTableViewController.create)
        )
        navigationItem.title = "Sent Memes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        // Load the memes data from the global context
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Sent Memes"
        navigationItem.backBarButtonItem = backItem
    }
    
    
    // MARK: Table View Data Source
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return memes.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MemeTableViewCell"
        )!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + "…" + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let detailController = storyboard!.instantiateViewController(
            withIdentifier: "MemeDetailViewController"
        ) as! MemeDetailViewController
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    // MARK: Supplementary Functions
    
    // Displays the Create View
    func create() {
        let memeCreateVC = storyboard!.instantiateViewController(
            withIdentifier: "MemeCreateViewController"
        )
        present(memeCreateVC, animated: true, completion: nil)
    }
}
