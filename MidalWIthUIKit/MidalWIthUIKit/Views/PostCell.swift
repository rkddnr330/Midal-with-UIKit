//
//  PostTableViewCell.swift
//  MidalWIthUIKit
//
//  Created by Park Kangwook on 2023/03/19.
//

import UIKit

final class PostCell: UITableViewCell {

    static let reuseID = "PostCell"
    static let rowHeight: CGFloat = 80     // Cell 길이

    var post: Post? {
        didSet {
            configureCell(item: post!)
        }
    }
    
    // MARK: - Cell 프로퍼티

    private let postLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 2
        label.textAlignment = .center

        return label
    }()

    // MARK: - Cell 메소드
    
    private func setup() {
        contentView.addSubview(postLabel)
        
        NSLayoutConstraint.activate([
            postLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            postLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureCell(item: Post) {
        postLabel.text = item.title
    }
    
    // MARK: - 라이프 사이클
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
