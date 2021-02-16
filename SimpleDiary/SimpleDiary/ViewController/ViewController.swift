//
//  ViewController.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/09.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var data: [Memo] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    private func setUp() {
        fetchData()
        setUpTableView()
    }
    
    private func setUpTableView() {
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
    
    private func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            let memos = try context.fetch(Memo.fetchRequest()) as! [Memo]
            data = memos
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func deleteData(at index: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            context.delete(data[index.row])
            try context.save()
            data.remove(at: index.row)
            tableView.deleteRows(at: [index], with: .automatic)
            fetchData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func touchedEditMode(_ sender: Any) {
        if tableView.isEditing {
            editButton.title = "편집"
            tableView.setEditing(false, animated: true)
        } else {
            editButton.title = "취소"
            tableView.setEditing(true, animated: true)
        }
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
        cell.configure(content: data[indexPath.row].content ?? "load failed")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteData(at: indexPath)
        default:
            break
        }
    }
    
}

extension ViewController: InputMemoDelegate {
    
    func addMemo(content: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Memo", in: context) else { return }
        
        let memo = NSManagedObject(entity: entity, insertInto: context)
        memo.setValue(content, forKey: "content")
        
        do {
            try context.save()
            fetchData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
