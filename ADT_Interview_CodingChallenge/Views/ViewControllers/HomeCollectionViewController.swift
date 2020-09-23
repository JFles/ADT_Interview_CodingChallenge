//
//  HomeCollectionViewController.swift
//  ADT_Interview_CodingChallenge
//
//  Created by Jeremy Fleshman on 9/22/20.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    // MARK: - Properties
    var characters = [RMCharacter]()
    var currentPage = 1
    var isLoading = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

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

            strongSelf.collectionView.reloadData()
            strongSelf.isLoading = false
        }
    }

    // MARK: - UICollectionView Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Character", for: indexPath) as? CharacterCollectionViewCell else { fatalError("Failed to dequeue collection view cell") }

        let character = characters[indexPath.row]

        if let url = URL(string: character.image) {
            cell.imageView.load(url: url)
        }
        cell.label.text = character.name

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }

        vc.character = characters[indexPath.row]

        navigationController?.pushViewController(vc, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == characters.count - 1 && !self.isLoading {
            loadMoreData()
        }
    }

    func loadMoreData() {
        self.isLoading = true
        currentPage += 1
        loadNetworkData(page: currentPage)
    }
}

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        let squareSize = width * 0.5 - 20
        return CGSize(width: squareSize, height: squareSize)
    }
}

