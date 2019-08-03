//
//  SearchViewController.swift
//  TheReel
//
//  Created by ashley canty on 4/25/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchBarField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.clipsToBounds = true
        searchButton.layer.cornerRadius = 8.0
        searchBarField.delegate = self
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    
    @IBAction func searchButtonDidTap() {
        if searchBarField.text == "" || searchBarField == nil {
            emptyTextField()
        } else {
            self.performSegue(withIdentifier: StoryBoardSegues.MovieSearchResults.rawValue, sender: nil)
        }
    }
    
    func emptyTextField(){
        let alert = UIAlertController(title: AlertMessages.EmptyMessageTitle.rawValue, message: AlertMessages.EmptyFieldMessage.rawValue, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertMessages.Okay.rawValue, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == StoryBoardSegues.MovieSearchResults.rawValue {
            let vc = segue.destination as! SearchResultsViewController
            vc.searchLabel = searchBarField.text
        } 
    }
}

