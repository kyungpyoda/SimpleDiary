//
//  ViewController.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/09.
//

import UIKit

class ViewController: UIViewController {
    
    var data: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    private func setUp() {
        data = ["abc", "가나다", "1234"]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MemoTableViewCell", bundle: nil), forCellReuseIdentifier: MemoTableViewCell.identifier)
    }
    
    @IBSegueAction func presentInputMemoViewController(_ coder: NSCoder) -> InputMemoViewController? {
        return InputMemoViewController(
            coder: coder,
            delegate: self
        )
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(content: data[indexPath.row])
        return cell
    }
    
}

extension ViewController: InputMemoDelegate {
    
    func addMemo(content: String) {
        data.append(content)
        tableView.reloadData()
    }
    
}
