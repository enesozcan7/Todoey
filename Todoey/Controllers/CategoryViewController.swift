//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Enes Ozcan on 16.06.2018.
//  Copyright © 2018 Enes Ozcan. All rights reserved.
//

import UIKit
import CoreData



class CategoryViewController: UITableViewController {

     var categoryArray = [Category]()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell

    }
    
    //MARK - TableView Data Source Methods
    
    
    //MARK - Data Manipulation Methods
    
    
    
    //MARK - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add category", style: .default, handler: ({ (action) in
            
            if (textField.text != nil) && (textField.text != ""){
                let tempCategory = Category(context: self.context)
                tempCategory.name = textField.text!
                self.categoryArray.append(tempCategory)
                self.saveData()
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
    func saveData() {
        
        do {
            try context.save()
        } catch  {
            print("error when encoding: \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        
        tableView.reloadData()
        
    }

    //MARK -Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    
    
}
