//
//  ViewController.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-21.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {
    
    private let viewModel: TodoListViewModel = TodoListViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colourHex = selectedCategory?.colour else { fatalError() }
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "000000")
    }
    
    // MARK: - Navbar setup
    private func updateNavBar(withHexCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    
    // MARK: - Tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! itemTableViewCell
        cell.textField.delegate = self
        
        if let item = viewModel.todoItems?[indexPath.row] {
            cell.textField.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(viewModel.todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textField.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.textField.backgroundColor = colour
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        var superActions: [SwipeAction] = super.tableView(tableView, editActionsForRowAt: indexPath, for: orientation)!
        
        let reminderAction = SwipeAction(style: .destructive, title: "Reminder") { (action, indexPath) in
            // reminder action code
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let reminderViewController = storyBoard.instantiateViewController(withIdentifier: "reminderView") as! ReminderViewController
            reminderViewController.todoListViewController = self
            reminderViewController.todoIndexPath = indexPath
            if let date = self.viewModel.todoItems?[indexPath.row].reminder {
                reminderViewController.switchOn = true
                reminderViewController.date = date
            } else {
                reminderViewController.switchOn = false
            }
            self.navigationController?.pushViewController(reminderViewController, animated: true)
        }
        
        reminderAction.image = UIImage(named: "calendar-icon")
        reminderAction.backgroundColor = UIColor.lightGray
        superActions.append(reminderAction)
        
        return superActions
    }
    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
         let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if (textField.text?.count)! > 0 {
                if let currentCategory = self.selectedCategory {
                    self.viewModel.save(name: textField.text!, currentCategory: currentCategory)
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    private func loadItems() {
        viewModel.todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = viewModel.todoItems?[indexPath.row] {
            viewModel.delete(item: item)
        }
    }
    
    func setReminder(indexPath: IndexPath, date: Date?) {
        if date != nil {
            viewModel.setItemReminder(indexPath: indexPath, reminderDate: date)
        } else {
            viewModel.setItemReminder(indexPath: indexPath)
        }
        tableView.reloadData()
    }
}

// MARK: - Searchbar
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.count)! > 0 {
            viewModel.todoItems = viewModel.todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        } else {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Textfield delegate
extension TodoListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let cell = textField.superview?.superview as? UITableViewCell, let table = cell.superview as? UITableView, let indexPath = table.indexPath(for: cell) {
            if (textField.text?.count)! > 0 {
                viewModel.updateItemText(indexPath: indexPath, newText: textField.text!)
            } else {
                textField.text = viewModel.todoItems?[indexPath.row].title
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
