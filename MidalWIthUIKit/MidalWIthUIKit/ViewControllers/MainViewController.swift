//
//  MainViewController.swift
//  MidalWIthUIKit
//
//  Created by Park Kangwook on 2023/03/19.
//

import UIKit

class MainViewController: UIViewController {
    
//    private let searchController: UISearchController = UISearchController()
    
    let departmentPosts: [Post] = {
        var arr = [Post]()
        arr += Array(
            repeating: Post(
                "이것은 학과의 장학금 게시글입니다. 클릭하면 게시글 정보를 볼 수 있는 링크로 넘어갑니다.",
                URL(string: "www.naver.com")!),
            count: 10)
        arr += Array(
            repeating: Post(
                "이것은 학과의 장학금 게시글입니다. ",
                URL(string: "www.naver.com")!),
            count: 10)
        
        return arr.shuffled()
    }()
    
    let centralPosts: [Post] = {
        var arr = [Post]()
        arr += Array(
            repeating: Post(
                "이것은 공식 홈페이지의 장학금 게시글입니다. 클릭하면 게시글 정보를 볼 수 있는 링크로 넘어갑니다.",
                URL(string: "www.google.com")!),
            count: 10)
        arr += Array(
            repeating: Post(
                "이것은 공식 홈페이지의 장학금 게시글입니다.",
                URL(string: "www.google.com")!),
            count: 10)
        
        return arr.shuffled()
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    private var filteredItems: [Post] = []
    private var receivedData: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 장학금"
        navigationController?.navigationBar.prefersLargeTitles = true // Enable large titles
        navigationItem.largeTitleDisplayMode = .always // Show the large title

//        searchController.searchResultsUpdater = self
//        navigationItem.searchController = searchController
        
        view.backgroundColor = .white
        
        setupTableView()
//        setupSearchController()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)   // Cell 등록 (코드 베이스라서)
        tableView.rowHeight = PostCell.rowHeight
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
    }

    
//    // SearchController에 대한 설정들
//    private func setupSearchController() {
//        navigationItem.searchController = searchController
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchResultsUpdater = self
//        navigationItem.hidesSearchBarWhenScrolling = false
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchString = searchController
//            .searchBar
//            .text?
//            .components(separatedBy: " ")
//            .joined(separator: ""),
//           searchString.isEmpty == false {
//            filteredItems = receivedData.filter { (item) -> Bool in
//                item.title
//                    .components(separatedBy: " ")
//                    .joined(separator: "")
//                    .localizedCaseInsensitiveContains(searchString)
//            }
//        } else {
//            filteredItems = receivedData
//        }
//        tableView.reloadData()
//    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return departmentPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as? PostCell else { return UITableViewCell() }
        cell.post = departmentPosts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return departmentPosts.count == 0 ? nil : "\(departmentPosts.count)개의 소식"
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
    }
}
