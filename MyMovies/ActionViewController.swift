//
//  ActionViewController.swift
//  moviesWithMVC
//
//  Created by Mohamed Sayed on 9/11/18.
//  Copyright © 2018 Mohamed Sayed. All rights reserved.
//

import Foundation
import UIKit

class ActionViewController:UITableViewController{
    var movies: [TMDBMovie] = [TMDBMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and set the logout button
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        TMDBClient.sharedInstance().getActionMovies { (movies, error) in
            if let movies = movies {
                self.movies = movies
                
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get cell type
        let cellReuseIdentifier = "ActionTableViewCell"
        let movie = movies[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?
        
        // set cell defaults
        cell?.textLabel!.text = movie.title
        cell?.imageView!.image = UIImage(named: "Film")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        
        
        if let posterPath = movie.posterPath {
            let _ = TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    performUIUpdatesOnMain {
                        cell?.imageView!.image = image
                        cell?.setNeedsLayout()
                        
                    }
                } else {
                    print(error ?? "empty error")
                }
            })
        }
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movies[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
