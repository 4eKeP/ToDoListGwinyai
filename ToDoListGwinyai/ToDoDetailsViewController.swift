//
//  ToDoDetailsViewController.swift
//  ToDoListGwinyai
//
//  Created by admin on 20.02.2023.
//

import UIKit

class ToDoDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!
    
    @IBOutlet weak var taskCompletionButton: UIButton!
    
    @IBOutlet weak var taskCompletionDate: UILabel!
    
    
    var toDoItem: ToDoItemModel!
    
    var toDoIndex: Int!
    
    weak var delegate: ToDoListDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        taskTitleLabel.text = toDoItem.name
        
        taskDetailsTextView.text = toDoItem.details
        
        if toDoItem.isComplete {
            
            disableButton()
            
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM dd, yyyy hh:mm"
        
        let taskDate = formatter.string(from: toDoItem.completionDate!)
        
        taskCompletionDate.text = taskDate
        
    }
    
    func disableButton() {
        
        taskCompletionButton.backgroundColor = UIColor.gray
        
        taskCompletionButton.isEnabled = false
        
    }
   
    
    @IBAction func taskDidComplete(_ sender: Any) {
        
        toDoItem.isComplete = true
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //delegate?.update(task: toDoItem, index: toDoIndex)
        delegate?.update()
        
        disableButton()
        
    }
    

}