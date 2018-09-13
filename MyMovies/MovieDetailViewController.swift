//
//  MovieDetailViewController.swift
//  moviesWithMVC
//
//  Created by Mohamed Sayed on 9/10/18.
//  Copyright © 2018 Mohamed Sayed. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MovieDetailViewController: UIViewController

class MovieDetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var toggleWatchlistButton: UIBarButtonItem!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    var movie: TMDBMovie?
    var isFavorite = false
    var isWatchlist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        // set the UI, then check if the movie is a favorite/watchlist and update the buttons!
        if let movie = movie {
            
            // set the title
            
            
            // setting some default UI ...
            posterImageView.image = UIImage(named: "MissingPoster")
            isFavorite = false
            
            // is the movie a favorite?
            TMDBClient.sharedInstance().getFavoriteMovies { (movies, error) in
                if let movies = movies {
                    
                    for movie in movies {
                        if movie.id == self.movie!.id {
                            self.isFavorite = true
                        }
                    }
                    

                    performUIUpdatesOnMain {
                        if self.isFavorite {
                            self.toggleFavoriteButton.tintColor = nil
                            
                            
                        } else {
                            self.toggleFavoriteButton.tintColor = .black
                        }
                    }
                } else {
                    print(error ?? "empty error")
                }
            }
            
            // is the movie on the watchlist?
            TMDBClient.sharedInstance().getWatchlistMovies { (movies, error) in
                if let movies = movies {
                    
                    for movie in movies {
                        if movie.id == self.movie!.id {
                            self.isWatchlist = true
                        }
                    }
                    
                    performUIUpdatesOnMain {
                        if self.isWatchlist {
                            self.toggleWatchlistButton.tintColor = nil
                        } else {
                            self.toggleWatchlistButton.tintColor = .black
                        }
                    }
                } else {
                    print(error ?? "empty error")
                }
            }
            
            // set the poster image
            if let posterPath = movie.posterPath {
                let _ = TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.DetailPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                    if let image = UIImage(data: imageData!) {
                        performUIUpdatesOnMain {
                            
                            self.posterImageView.image = image
                        }
                    }
                })
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func toggleFavorite(_ sender: AnyObject) {
        
        let shouldFavorite = !isFavorite
        
        TMDBClient.sharedInstance().postToFavorites(movie!, favorite: shouldFavorite) { (statusCode, error) in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    self.isFavorite = shouldFavorite
                    performUIUpdatesOnMain {
                        self.toggleFavoriteButton.tintColor = (shouldFavorite) ? nil : .black
                    }
                } else {
                    print("Unexpected status code \(statusCode!)")
                }
            }
        }
    }
    
    @IBAction func toggleWatchlist(_ sender: AnyObject) {
        
        let shouldWatchlist = !isWatchlist
        
        TMDBClient.sharedInstance().postToWatchlist(movie!, watchlist: shouldWatchlist) { (statusCode, error) in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    self.isWatchlist = shouldWatchlist
                    performUIUpdatesOnMain {
                        self.toggleWatchlistButton.tintColor = (shouldWatchlist) ? nil : .black
                    }
                } else {
                    print("Unexpected status code \(statusCode!)")
                }
            }
        }
    }
}
