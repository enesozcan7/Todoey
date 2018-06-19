//
//  ViewController.swift
//  Todoey
//
//  Created by Enes Ozcan on 12.06.2018.
//  Copyright © 2018 Enes Ozcan. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeCellViewController{
    
    let realm = try! Realm()
    var toDoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = toDoItems?[indexPath.row]
        cell.textLabel?.text = item?.title ?? "no item is written"
        
        cell.accessoryType = item?.done ?? false ? .checkmark : .none
        
        return cell
        
    }
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("error when updting realm data : \(error)")
            }
            
        }
        tableView.reloadData()
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add item", style: .default, handler: ({ (action) in
            print(textField.text!)
            if (textField.text != nil) && (textField.text != ""){
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let tempItem = Item()
                            tempItem.title = textField.text!
                            tempItem.dataCreated = Date()
                            currentCategory.items.append(tempItem)
                        }
                    } catch {
                        print("error when saving items : \(error)")
                    }
                }
                self.tableView.reloadData()
            }
            }
            )
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { (alertTextFied) in
            alertTextFied.placeholder = "Enter new item"
            textField = alertTextFied
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true,completion: nil)
    }
    
    //MARK - Save to plist
    
    
    
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("error when saving items : \(error)")
            }
        }
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dataCreated", ascending: true)
        tableView.reloadData()
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

