//
//  AddTaskViewController.swift
//  ToDoListGwinyai
//
//  Created by admin on 20.02.2023.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!
    
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var touchView: UIView = {
        
        let _touchView = UIView()
        
        _touchView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        
        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        _touchView.isUserInteractionEnabled = true
        
        _touchView.addGestureRecognizer(touchViewTapped)
       
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
       
        return _touchView
        
    }()
    
    let toolBarDone = UIToolbar.init()
    
    var activeTextField: UITextField?
    
    var activeTextView: UITextView?
    
    //переменная для того что бы не менять метод наблюдателя с keyboardWillShowNotification на keyboardDidShowNotification
//    var keyboardNotification: NSNotification?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let navigationItem = UINavigationItem(title: "Add task")
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTouch))
        
        navigationBar.items = [navigationItem]
        
        taskDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        taskDetailsTextView.layer.borderWidth = CGFloat(1)
        
        taskDetailsTextView.layer.cornerRadius = CGFloat(3)
        
        toolBarDone.sizeToFit()
        
        toolBarDone.barTintColor = UIColor.red
        
        toolBarDone.isTranslucent = false
        //пустое место
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        //кнопка
        let barButtonDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        barButtonDone.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        // пустые места по краям что бы кнопка в середине была
        toolBarDone.items = [flexSpace, barButtonDone, flexSpace]
        
        taskNameTextField.inputAccessoryView = toolBarDone
        
        taskDetailsTextView.inputAccessoryView = toolBarDone
        
        taskNameTextField.delegate = self
        
        taskDetailsTextView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForkeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterForkeyboardNotification()
    }
    
    func registerForkeyboardNotification() {
        // разобраться с последовательностью работы наблюдателя
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWasShown(notification:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        print("добавлен наблюдатель keyboardWillShowNotification")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        print("добавлен наблюдатель keyboardWillHideNotification")
        
    }
    func deregisterForkeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        print("убран наблюдатель keyboardWillShowNotification")
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        print("убран наблюдатель keyboardWillShowNotification")
        
    }
    
    @objc func keyBoardWasShown(notification: NSNotification) {
        
        view.addSubview(touchView)
        print("добавлен прозрачьный view для убирания клавиатуры")
        
        
        //референс на уведомление что бы не менять метод наблюдателя с keyboardWillShowNotification на keyboardDidShowNotification
//        self.keyboardNotification = notification
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height + toolBarDone.frame.size.height + 50, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.verticalScrollIndicatorInsets = contentInsets
        //проверить почему на второй раз поле на ровне с кнопкой done(не учитывет высоту кнопки в последующие после первого раза запросы? поставил дополнительную высоту в 50 что бы было видно поле) но в первый раз все отлично урок 18
        //var aRect: CGRect = UIScreen.main.bounds
        guard var aRect: CGRect = view.window?.windowScene?.screen.bounds else {return}
        
        aRect.size.height -= keyboardSize!.height
       
        if activeTextField != nil {
            if (!aRect.contains(activeTextField!.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
            }
        }
        else if activeTextView != nil {
            
            // разобраться зачем складывать высоту textView 2 раза урок 19
            let textViewPoint: CGPoint = CGPoint(x: activeTextView!.frame.origin.x, y: activeTextView!.frame.size.height + activeTextView!.frame.size.height)
            
            if (aRect.contains(textViewPoint)) {
                
                self.scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)
                
            }
        }
        
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        
        touchView.removeFromSuperview()
        
        print("убран прозрачьный view для убирания клавиатуры")
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.view.endEditing(true)
        
        
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        print("убрана клавиатура от нажатия на view")
    }
    
    
//    @objc func cancelButtonDidTouch(){
//        dismiss(animated: true)
//    }
    
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        
        let validation = Validation()
        
        var taskName: String = ""
        
        do {
            taskName = try validation.validate(text: taskNameTextField.text, minlength: 4, maxLength: 15)
        }
        catch
            ValidationError.Empty{
                reportError(title: "Task name is empty", message: "Task name field is required")
                return
            }
        catch ValidationError.Short{
            reportError(title: "Task name is too short", message: "Please enter a task name that is between 4 and 15 characters long")
            return
        }
        catch ValidationError.Long{
            reportError(title: "Task name is too long", message: "Please enter a task name that is between 4 and 15 characters long")
            return
        }
        catch{
            reportError(title: "Task Name Invalid", message: "Please check the task name you have entered")
            return
        }
        
        
        if taskDetailsTextView.text.isEmpty {
            
            reportError(title: "Invalid Task Details", message: "Task details are required")
            
            return
            
        }
        
        
        let taskDetails: String = taskDetailsTextView.text
        
        let complitionDate: Date = taskCompletionDatePicker.date
        
        if complitionDate < Date() {
            
            reportError(title: "Invalid Task Data", message: "Date must be in the future")
            
            return
        }
        
        
        guard let realm = LocalDataBaseManager.realm else {
            reportError(title: "Error", message: "new task could not be created")
            return
        }
        let nextTaskId = (realm.objects(Task.self).max(ofProperty: "id") as Int? ?? 0) + 1
        
        //let newTask = Task(name: taskName, details: taskDetails, completionDate: complitionDate)
        let newTask = Task()
        newTask.id = nextTaskId
        
        newTask.name = taskName
        newTask.details = taskDetails
        newTask.completionDate = complitionDate
        newTask.isComplete = false
        
        do {
            try realm.write{
                realm.add(newTask)
            }
        }catch let error as NSError {
            print(error.localizedDescription)
            reportError(title: "Error", message: "A new task could not be created")
            return
        }
        
        
        
    
        
        NotificationCenter.default.post(name: NSNotification.Name.init("AddTask"), object: nil)
        
       
        dismiss(animated: true)
        
        // для более продвинутых проверок нужно использовать regular expressions Swift
        /*
        //проверка если символов более 50
        if taskName.count > 50 {
            
            //error report
            
            return
        }
        
        //проверка если цифры
        guard let isTaskNameANumber = Int(taskName) else {
            
            // report error
            return
        }
         */
        
    }
    
    func reportError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
            
        }
        
        
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    

}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
       activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
}

extension AddTaskViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
        
        //код для того что бы клавиатура не закрывала textView, что бы не менять метод наблюдателя с keyboardWillShowNotification на keyboardDidShowNotification
        
//        guard let notification = self.keyboardNotification else {return}
//
//        let info: NSDictionary = notification.userInfo! as NSDictionary
//
//        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//
//        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height + toolBarDone.frame.size.height + 50, right: 0.0)
//
//        self.scrollView.contentInset = contentInsets
//
//        self.scrollView.verticalScrollIndicatorInsets = contentInsets
//
//        guard var aRect: CGRect = view.window?.windowScene?.screen.bounds else {return}
//
//        aRect.size.height -= keyboardSize!.height
//
//            // разобраться зачем складывать высоту textView 2 раза урок 19
//            let textViewPoint: CGPoint = CGPoint(x: textView.frame.origin.x, y: textView.frame.size.height + textView.frame.size.height)
//
//            if (aRect.contains(textViewPoint)) {
//
//                self.scrollView.scrollRectToVisible(textView.frame, animated: true)
//        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
    
}
