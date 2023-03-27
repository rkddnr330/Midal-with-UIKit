//
//  MainViewController.swift
//  MidalWIthUIKit
//
//  Created by Park Kangwook on 2023/03/19.
//

import UIKit

enum category {
    case department, central
}

class MainViewController: UIViewController, UISearchResultsUpdating {
    private let searchController: UISearchController = UISearchController()
    private var searchText: String? = String()
    
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
            count: 5)
        arr += Array(
            repeating: Post(
                "이것은 공식 홈페이지의 장학금 게시글입니다.",
                URL(string: "www.google.com")!),
            count: 7)
        
        return arr.shuffled()
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    var isExpandedDepartment: Bool = false
    var isExpandedCentral: Bool = false
    
    private var searchResult: [category:[Post]] = [.department:[], .central:[]]
    private var receivedData: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 장학금"
        navigationController?.navigationBar.prefersLargeTitles = true // Enable large titles
        navigationItem.largeTitleDisplayMode = .always // Show the large title

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        view.backgroundColor = .white
        
        setupTableView()
        setupSearchController()
        dismissKeyboard()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)   // Cell 등록 (코드 베이스라서)
        tableView.register(PostTableHeaderView.self, forHeaderFooterViewReuseIdentifier: PostTableHeaderView.reuseID)
        tableView.rowHeight = PostCell.rowHeight
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
        
        searchResult[.department] = departmentPosts
        searchResult[.central] = centralPosts
    }

    
    // SearchController에 대한 설정들
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.window?.endEditing(true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController
            .searchBar
            .text?
            .components(separatedBy: " ")
            .joined(separator: "")
        else {
            searchResult[.department] = departmentPosts
            searchResult[.central] = centralPosts
            return
        }
        
        guard !text.isEmpty else {
            searchResult[.department] = departmentPosts
            searchResult[.central] = centralPosts
            tableView.reloadData()
            return
        }
        
        searchResult[.department] = departmentPosts.filter { (item) -> Bool in
            item.title
                .components(separatedBy: " ")
                .joined(separator: "")
                .localizedCaseInsensitiveContains(text)
        }
        
        searchResult[.central] = centralPosts.filter { (item) -> Bool in
            item.title
                .components(separatedBy: " ")
                .joined(separator: "")
                .localizedCaseInsensitiveContains(text)
        }
        
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return isExpandedDepartment ? 0 : searchResult[.department]?.count ?? 0
            
        case 1 :
            return isExpandedCentral ? 0 : searchResult[.central]?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as? PostCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.post = searchResult[.department]![indexPath.row]
        } else {
            cell.post = searchResult[.central]![indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 0 ? "\(searchResult[.department]?.count ?? 0)개의 소식" : "\(searchResult[.central]?.count ?? 0)개의 소식"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PostTableHeaderView.reuseID) as! PostTableHeaderView
        
        if section == 0 {
            headerView.titleLabel.text = "화공생명 환경공학부 환경공학전공"
            headerView.arrowButton.tag = section
        } else {
            headerView.titleLabel.text = "PNU 공지사항"
            headerView.arrowButton.tag = section
        }

        headerView.arrowButton.addTarget(self, action: #selector(arrowButtonTapped(_:)), for: .touchUpInside)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func arrowButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        if section == 0 {
            isExpandedDepartment.toggle()
            tableView.reloadSections([section], with: .automatic)
        } else {
            isExpandedCentral.toggle()
            tableView.reloadSections([section], with: .automatic)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = URL(string: "https://www.naver.com") {
            UIApplication.shared.open(url)
        }
    }
}
