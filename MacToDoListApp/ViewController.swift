//
//  ViewController.swift
//  MacToDoListApp
//
//  Created by Abhishek Yadav on 26/07/24.
//

import Cocoa

class ViewController: NSViewController {
    
    var tableView: NSTableView!
    var textField: NSTextField!
    var addButton: NSButton!
    var todos: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadTodos()
    }
    
    func setupUI() {
        // Set up text field
        textField = NSTextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholderString = " Enter a new to-do"
        view.addSubview(textField)
        
        // Set up add button
        addButton = NSButton(title: "Add", target: self, action: #selector(addTodoClicked))
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        // Set up table view
        let scrollView = NSScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.borderType = .bezelBorder
        scrollView.hasVerticalScroller = true
        view.addSubview(scrollView)
        
        tableView = NSTableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "TodoColumn"))
        column.title = "To-Do Items"
        tableView.addTableColumn(column)
        tableView.headerView = nil
        
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollView.documentView = tableView
        
        // Add constraints
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            textField.heightAnchor.constraint(equalToConstant: 30),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 80),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func addTodoClicked() {
        let newTodo = textField.stringValue
        if !newTodo.isEmpty {
            todos.append(newTodo)
            textField.stringValue = ""
            tableView.reloadData()
            saveTodos()
        }
    }
    
    func saveTodos() {
        UserDefaults.standard.set(todos, forKey: "todos")
    }
    
    func loadTodos() {
        if let savedTodos = UserDefaults.standard.array(forKey: "todos") as? [String] {
            todos = savedTodos
            tableView.reloadData()
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("Number of rows: \(todos.count)")  // Debugging statement
        return todos.count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = NSUserInterfaceItemIdentifier("TodoCell")
        var cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView
        if cell == nil {
            cell = NSTableCellView()
            cell?.identifier = cellIdentifier
            
            let textField = NSTextField(frame: NSRect(x: 10, y: 10, width: tableColumn?.width ?? tableView.frame.width, height: 30))
            textField.isBordered = false
            textField.backgroundColor = .clear
            textField.isEditable = false
            textField.textColor = .systemRed
            
            cell?.addSubview(textField)
            cell?.textField = textField
        }
        print("Configuring cell at row: \(row) with text: \(todos[row])")  // Debugging statement
        cell?.textField?.stringValue = todos[row]
        return cell
    }
}
