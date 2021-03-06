//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Enes Ozcan on 16.06.2018.
//  Copyright © 2018 Enes Ozcan. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryViewController: SwipeCellViewController{
    
    
    
    let realm = try! Realm()
    var categoryArray: Results<Category>?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadCategories()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoryArray?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "no category added yet"
        return cell
        
    }
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    //MARK - TableView Data Source Methods
    
    
    //MARK - Data Manipulation Methods
    override func updateModel(at indexPath: IndexPath) {
                    if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                        do {
                            try self.realm.write {
                                self.realm.delete(categoryForDeletion)
                            }
                        } catch  {
                            print("error when encoding: \(error)")
                        }
                    }
    }
    
    
    //MARK - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add category", style: .default, handler: ({ (action) in
            
            if (textField.text != nil) && (textField.text != ""){
                let tempCategory = Category()
                tempCategory.name = textField.text!
                self.save(category : tempCategory)
            } }
            )
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { (alertTextFied) in
            alertTextFied.placeholder = "Enter new category"
            textField = alertTextFied
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true,completion: nil)
    }
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("error when encoding: \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK -Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
}
// MARK - Swipe View Cell Delegate methods
