//
//  HomeCollectionViewController.swift
//  ADT_Interview_CodingChallenge
//
//  Created by Jeremy Fleshman on 9/22/20.
//

import UIKit

private let reuseIdentifier = "Character"

class HomeCollectionViewController: UICollectionViewController {
    // MARK: - Properties
    var characters = [RMCharacter]()
    var currentPage = 1
    var isLoadingPage = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        configureNavigationBar()
        loadNetworkData(page: currentPage)
    }

    fileprivate func configureNavigationBar() {
        title = "Rick and Morty Character List"
    }

    fileprivate func loadNetworkData(page: Int) {
        let urlString = "https://rickandmortyapi.com/api/character/?page=\(page)"

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else { return }

            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    strongSelf.parse(json: data)
                } else {
                    print("Failed to create data from network call")
                }
            }
        }
    }

    fileprivate func parse(json: Data) {
        let decoder = JSONDecoder()

        if let characters = try? decoder.decode(RMCharacters.self, from: json) {
            self.characters.append(contentsOf: characters.results)
        } else {
            print("Failed to decode json")
        }

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }

            #warning("Make sure this is performant")
            strongSelf.collectionView.reloadData()
            strongSelf.isLoadingPage = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
