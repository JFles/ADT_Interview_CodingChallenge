//
//  HomeViewController.swift
//  ADT_Interview_CodingChallenge
//
//  Created by Jeremy Fleshman on 9/22/20.
//

import UIKit

class HomeViewController: UITableViewController {
    // MARK: - Properties
    var characters = [RMCharacter]()
    var currentPage = 1
    var isLoadingPage = false


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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

            strongSelf.tableView.reloadData()
            strongSelf.isLoadingPage = false
        }
    }
}

// MARK: - TableView
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Character", for: indexPath)

        cell.textLabel?.text = characters[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }

        vc.character = characters[indexPath.row]

        navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        #warning("Change to prefetch data sources for tableviews")
        // scrolling to last row visible -> load next page
        if indexPath.row == characters.count - 1 {
            currentPage += 1
            loadNetworkData(page: currentPage)
            isLoadingPage = true
        }
    }
}

