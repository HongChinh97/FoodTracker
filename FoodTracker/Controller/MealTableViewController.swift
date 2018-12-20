//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by admin on 7/31/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import os.log
import CoreData

class MealTableViewController: UITableViewController{
    
    var meals = DataService.shared.mocMeals
    let searchController = UISearchController(searchResultsController: nil)
    var filteredData = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        // Ẩn/ hiện Navigation khi nút search active
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        // true để search bar của chúng ta không bị lỗi layout khi sử dụng
        definesPresentationContext = true
        
        //Sử dụng mục nút chỉnh sửa do bộ điều khiển xem bảng cung cấp.
        navigationItem.leftBarButtonItem = editButtonItem
        //call fetchedResultsController
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Meal"
        navigationItem.searchController = searchController
        filteredData = meals
        tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instant of MealTableViewCell.")
        }
        
        let meal = filteredData[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo as? UIImage
        cell.ratingControl.rating = Int(meal.rating)
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return}
        filteredData = searchText.isEmpty ? (meals): (meals.filter({(data) -> Bool in return
            (data.name?.lowercased().contains(searchText.lowercased()))!
        }))
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let detailViewController = segue.destination as? MealViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                    detailViewController.food = filteredData[indexPath.row]
                }
            }
        }
    @IBAction func unwindToMealList (_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? MealViewController,let meal = sourceVC.food {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                if let index = meals.index(of: filteredData[selectedIndexPath.row]) {
                    meals[index] = meal
                    filteredData = meals
                }
            } else {
                meals.append(meal)
                filteredData = meals
            }
            tableView.reloadData()
            DataService.shared.saveData()
        }
    }
   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let meal = filteredData[indexPath.row]
            filteredData.remove(at: indexPath.row)
            DataService.shared.remove(food: meal)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            print("delete")
        }
        tableView.reloadData()
        }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    


}
