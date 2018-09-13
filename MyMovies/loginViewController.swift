//
//  loginViewController.swift
//  moviesWithMVC
//
//  Created by Mohamed Sayed on 9/9/18.
//  Copyright © 2018 Mohamed Sayed. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {

    @IBOutlet weak var loginButton: BorderedButton!
    
    @IBOutlet weak var debugTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButton.layer.cornerRadius = 20
        
    }

    @IBAction func loginPressed(_ sender: Any) {
        TMDBClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    private func completeLogin() {

        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
        
    }
    
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
}
/*

 */

