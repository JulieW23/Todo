//
//  CategoryViewController.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-21.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class CategoryViewController: SwipeTableViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private let viewModel: CategoryViewModel = CategoryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.delegate = self
        tableView.addGestureRecognizer(longPress)
        doneButton.title = ""
        
        viewModel.loadCategories()
        tableView.reloadData()
    }
    
    // MARK: - reorder category functions
    @objc func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        self.title = "Rearrange"
        doneButton.title = "Done"
        self.tableView.isEditing = true
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.title = "Categories"
        tableView.isEditing = false
        doneButton.title = ""
    }
    
    // MARK: - Tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = viewModel.categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        var superActions: [SwipeAction] = super.tableView(tableView, editActionsForRowAt: indexPath, for: orientation)!
        
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            self.updateModel(at: indexPath)
//        }
//
        let colourAction = SwipeAction(style: .destructive, title: "Colour") { action, indexPath in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let colourViewController = storyBoard.instantiateViewController(withIdentifier: "colourView") as! ColourViewController
            colourViewController.categoryViewController = self
            colourViewController.categoryIndexPath = indexPath
            self.navigationController?.pushViewController(colourViewController, animated: true)
        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
        colourAction.image = UIImage(named: "colour-picker-icon")
        colourAction.backgroundColor = UIColor.orange
//
        superActions.append(colourAction)
        return superActions
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.reorder(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }

    // MARK: - Tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TodoListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = viewModel.categories?[indexPath.row]
            }
        }
    }
    
    // MARK: - Updating data
    func changeCategoryColour(indexPath: IndexPath, colour: UIColor) {
        viewModel.updateColour(indexPath: indexPath, hexValue: colour.hexValue())
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        // delete a category
        if let categoryForDeletion = self.viewModel.categories?[indexPath.row] {
            self.viewModel.delete(category: categoryForDeletion)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if (textField.text?.count)! > 0 {
                self.viewModel.save(name: textField.text!, colour: RandomFlatColorWithShade(.light).hexValue())
                self.tableView.reloadData()
            
            }
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
}
