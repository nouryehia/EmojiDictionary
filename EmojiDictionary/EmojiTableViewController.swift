/* EmojiTableViewController.swift
   EmojiDictionary
   Creates a dictionary of emojis, allowing the user to add, remove, or edit items.
   Created by Nour Yehia on 8/14/18.
   Copyright © 2018 Nour Yehia. All rights reserved. */

import UIKit

// THROWS AN ERROR WHEN EDITING AN EMOJI AND CHANGING ITS CATEGORY. NEEDS FIXING. PAST ATTEMPTS UNSUCCESSFUL.

class EmojiTableViewController: UITableViewController {
    
    // Array of Array of Emojis that holds all the emojis. 2D, so the list can be divided into categories.
    var emojis = [[Emoji]]()
    
    // Allows user to edit the table when the edit button is tapped.
    @IBAction func editButtonTapped(_ sender: Any) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    // Called once the view controller has loaded its view hierarchy into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load previously saved emojis if available. Otherwise load the default list.
        if let savedEmojis = Emoji.loadFromFile() {
            emojis = savedEmojis
        }
        else {
            emojis = Emoji.loadSampleEmojis()
        }
    }
    
    // Called before the view appears.
    override func viewWillAppear(_ animated: Bool) {
        // Reload everything from scrath.
        tableView.reloadData()
        // Make it easier to read if device is held horizontally.
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
        
    // Counts the number of categories to determine the number of sections in the table.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return emojis.count
    }
    
    // Counts the number of emoji in each category to determine the number of rows in each section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis[section].count
    }
    
    // Loads cell with approporiate information depending on emoji it holds.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
        let category = emojis[indexPath.section]
        let emoji = category[indexPath.row]
        cell.update(with: emoji)
        cell.showsReorderControl = true
        return cell
    }
    
    //Removes delete button.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle  {
            return .delete
    }
    
    // Determine what happens when remove button is tapped.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove emoji from array and cell from table.
            emojis[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        // Resave the list.
        Emoji.saveToFile(emojis)
    }
    
    // Allows user to move emojis around.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = emojis[fromIndexPath.section].remove(at: fromIndexPath.row)
        emojis[to.section].insert(movedEmoji, at: to.row)
        tableView.reloadData()
        Emoji.saveToFile(emojis)
        
    }
 
    // Determines the title of each section based on category.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Smileys & People"
            case 1: return "Animals"
            case 2: return "Food"
            case 3: return "Activities"
            case 4: return "Objects"
            case 5: return "Hearts"
            case 6: return "Flags"
            default: return "Unnamed Category"
        }
    }
    
    // Prepares for segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationViewController = segue.destination as? UINavigationController else {return}
        let addEditEmojiTableViewController = navigationViewController.viewControllers.first as! AddEditEmojiTableViewController
            if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "EditEmoji" {
            // Provide the next tableview controller with info about emoji to be edited.
            addEditEmojiTableViewController.emoji = emojis[indexPath.section][indexPath.row]
            addEditEmojiTableViewController.category = indexPath.section
        }
    }
    
    // Determines what happens when user saves an emoji (in other view controller)
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue){
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddEditEmojiTableViewController
        if let emoji = sourceViewController.emoji {
            let category = sourceViewController.category!
            if var selectedIndexPath = tableView.indexPathForSelectedRow {
                // If editing emoji, update cell.
                if category == selectedIndexPath.section {
                    emojis[selectedIndexPath.section][selectedIndexPath.row] = emoji
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    emojis[selectedIndexPath.section].remove(at: selectedIndexPath.row)
                    let newIndexPath = IndexPath(row: emojis[category].count, section: category)
                    emojis[category].append(emoji)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
            else {
                // Otherwise create a new one.
                let newIndexPath = IndexPath(row: emojis[category].count, section: category)
                emojis[category].append(emoji)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        // Resave the list.
        Emoji.saveToFile(emojis)
    }
}
