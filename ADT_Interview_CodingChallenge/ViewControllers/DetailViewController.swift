//
//  DetailViewController.swift
//  ADT_Interview_CodingChallenge
//
//  Created by Jeremy Fleshman on 9/22/20.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - Properties
    var character: RMCharacter?
    @IBOutlet var characterImage: UIImageView!
    @IBOutlet var tableView: UITableView!


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    fileprivate func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

// MARK: - TableView DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("Implement character property count")
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterDetail", for: indexPath)

        cell.textLabel?.text = "foo\(indexPath.row)"

        return cell
    }
}

// MARK: - TableView Delegate
extension DetailViewController: UITableViewDelegate {

}


