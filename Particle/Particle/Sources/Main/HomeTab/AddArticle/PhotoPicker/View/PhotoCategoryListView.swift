//
//  PhotoCategoryListView.swift
//  Particle
//
//  Created by 이원빈 on 5/22/24.
//

import UIKit
import RxRelay

final class PhotoCategoryListView: UITableView {
    var data: [String] = ["최근항목","스크린샷","셀피","비디오","즐겨찾는 항목"]
    var selected = BehaviorRelay<String>(value: "최근항목")
    
    // MARK: - Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension PhotoCategoryListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("select: \(data[indexPath.row])")
        selected.accept(data[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
