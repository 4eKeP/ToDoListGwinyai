//
//  ToDoListViewController.swift
//  ToDoListGwinyai
//
//  Created by admin on 20.02.2023.
//

import UIKit

protocol ToDoListDelegate: AnyObject {
    
    //func update(task: ToDoItemModel, index: Int)
    func update()
    
}

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var toDoItems: [ToDoItemModel] {
        
        do {
            
            return try context.fetch(ToDoItemModel.fetchRequest())
            
        } catch {
            
            print("Couldn't fetch data")
            
        }
        return [ToDoItemModel]()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        title = "To Do List"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        //передача данных с помощью NSNotification
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(_ :)), name: NSNotification.Name.init(rawValue: "com.todolistapp.addtask"), object: nil)
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        tableView.setEditing(false, animated: true)
        
    }
    //передача данных с помощью NSNotification
    @objc func addNewTask(_ notification: NSNotification) {
        
        
        
       /*
        var toDoItem: ToDoItemModel!
        
        if let task = notification.object as? ToDoItemModel {
            
            toDoItem = task
            
        }
        /*
        else if let taskDict = notification.userInfo as? NSDictionary {
            
            guard let task = taskDict["Task"] as? ToDoItemModel else {return}
            
            toDoItem = task
            
        }*/
        else{
            return
        }
        
        toDoItems.append(toDoItem)
        
        toDoItems.sort(by: {$0.completionDate < $1.completionDate})
        */
        tableView.reloadData()
            
        
    }
    
    @objc func addTapped() {
        
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
        
    }
    
    @objc func editTapped() {
        
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
            
        }else{
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, success in
            
            let toDoItem = self.toDoItems[indexPath.row]
            
            self.context.delete(toDoItem)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            //self.toDoItems.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = toDoItems[indexPath.row]
        
        let toDoTuple = (indexPath.row, selectedItem)
        
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let toDoItem = toDoItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem")!
        
        cell.textLabel?.text = toDoItem.name
        
        cell.detailTextLabel?.text = toDoItem.isComplete ? "Complete" : "Incomlete"
//         разобраться с новым образом отображения UIContentConfiguration
//        var content = cell.defaultContentConfiguration()
//
//        content.text = toDoItem.name
//
//        content.secondaryText = toDoItem.isComplete ? "Complete" : "Incomlete"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TaskDetailsSegue" {
            
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else {return}
            
            guard let toDoTuple = sender as? (Int, ToDoItemModel) else {return}
            
            destinationVC.toDoIndex = toDoTuple.0
            
            destinationVC.toDoItem = toDoTuple.1
            
            destinationVC.delegate = self
            
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "com.todolistapp.addtask"), object: nil)
            
        }
        
}

extension ToDoListViewController: ToDoListDelegate {
   
    func update() {
    //func update(task: ToDoItemModel, index: Int) {
        
        //toDoItems[index] = task
        
        tableView.reloadData()
        
    }
  
}
