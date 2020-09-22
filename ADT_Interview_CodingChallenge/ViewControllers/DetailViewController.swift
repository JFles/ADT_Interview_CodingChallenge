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

        configureNavigationBar()
        configureCharacterImage()
        configureTableView()
    }

    fileprivate func configureNavigationBar() {
        title = character?.name
    }

    fileprivate func configureCharacterImage() {
        guard let url = URL(string: character?.image ?? "") else { return }

        characterImage.load(url: url)
        characterImage.contentMode = .scaleAspectFill
    }

    fileprivate func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

// MARK: - TableView DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("Refactor this")
        let mirror = Mirror(reflecting: character!)
        var rowCount = 0

        for child in mirror.children {
            guard let label = child.label else { return 0 }

            for detail in RMCharacterDetails.allCases {
                if label == detail.rawValue {
                    rowCount += 1
                }
            }
        }

        return rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterDetail", for: indexPath)

        let index = indexPath.row
        switch index {
            case 0:
                setCellTitle(cell, to: "Name")
                setCellSubtitle(cell, to: character?.name ?? "")
            case 1:
                setCellTitle(cell, to: "Status")
                setCellSubtitle(cell, to: character?.status ?? "")
            case 2:
                setCellTitle(cell, to: "Species")
                setCellSubtitle(cell, to: character?.species ?? "")
            default:
                break
        }
        return cell
    }

    fileprivate func setCellTitle(_ cell: UITableViewCell, to text: String) {
        cell.textLabel?.text = text
    }

    fileprivate func setCellSubtitle(_ cell: UITableViewCell, to text: String) {
        cell.detailTextLabel?.text = text
    }
}

// MARK: - TableView Delegate
extension DetailViewController: UITableViewDelegate {

}


