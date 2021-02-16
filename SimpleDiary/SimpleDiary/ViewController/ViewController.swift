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
    
    private func updateData(memo: Memo, newContent: String?, newState: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            if let newContent = newContent {
                memo.setValue(newContent, forKey: "content")
            }
            if let newState = newState {
                memo.setValue(newState, forKey: "state")
            }
            try context.save()
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
        cell.configure(memo: data[indexPath.row])
        cell.delegate = self
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
        
        let newMemo = NSManagedObject(entity: entity, insertInto: context)
        newMemo.setValue(content, forKey: "content")
        
        do {
            try context.save()
            fetchData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension ViewController: ChangeMemoStateDelegate {
    func changeState(of cell: MemoTableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else {
            return
        }
        let memo = data[index]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let notInProgressAction = UIAlertAction(title: "X 미진행", style: .default, handler: { [weak self] _ in
            self?.updateData(memo: memo, newContent: nil, newState: "notIntProgress")
            self?.fetchData()
        })
        let delayedAction = UIAlertAction(title: "-> 미룸", style: .default, handler: { [weak self] _ in
            self?.updateData(memo: memo, newContent: nil, newState: "delayed")
            self?.fetchData()
        })
        let inProgressAction = UIAlertAction(title: "~~ 진행중", style: .default, handler: { [weak self] _ in
            self?.updateData(memo: memo, newContent: nil, newState: "inProgress")
            self?.fetchData()
        })
        let doneAction = UIAlertAction(title: "O 완료", style: .default, handler: { [weak self] _ in
            self?.updateData(memo: memo, newContent: nil, newState: "done")
            self?.fetchData()
        })
        alert.addAction(notInProgressAction)
        alert.addAction(delayedAction)
        alert.addAction(inProgressAction)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }
}
