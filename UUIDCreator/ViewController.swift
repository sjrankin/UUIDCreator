//
//  ViewController.swift
//  UUIDCreator
//
//  Created by Stuart Rankin on 12/10/20.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ClipBoard.declareTypes([.string], owner: nil)
    }
    
    var ClipBoard = NSPasteboard.general
    
    var UUIDList = [UUID]()
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return UUIDList.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 32.0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        var CellContents = ""
        var CellIdentifier = ""
        if tableColumn == tableView.tableColumns[0]
        {
            CellIdentifier = "UUIDColumn"
            CellContents = UUIDList[row].uuidString
        }
        else
        {
            let Button = MakeCopyButton(row)
            return Button
        }
        
        let Cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifier), owner: self) as? NSTableCellView
        Cell?.textField?.stringValue = CellContents
        Cell?.textField?.font = NSFont.monospacedSystemFont(ofSize: 16.0, weight: .bold)
        return Cell
    }
    
    func MakeCopyButton(_ Index: Int) -> NSButton
    {
        let Button = NSButton(title: "Copy", target: self, action: #selector(HandleCopyButton))
        Button.isBordered = false
        Button.bounds = NSRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 24))
        Button.wantsLayer = true
        Button.layer?.backgroundColor = NSColor.systemYellow.cgColor
        Button.tag = Index
        Button.font = NSFont.systemFont(ofSize: 14, weight: .bold)
        let TextAttributes: [NSAttributedString.Key: Any] =
            [
                .foregroundColor: NSColor.black as Any,
                .font: NSFont.systemFont(ofSize: 14, weight: .bold)
                
            ]
        Button.attributedTitle = NSMutableAttributedString(string: "Copy", attributes: TextAttributes)
        return Button
    }
    
    @objc func HandleCopyButton(_ sender: Any)
    {
        if let Button = sender as? NSButton
        {
            let Index = Button.tag
            ClipBoard.setString(UUIDList[Index].uuidString, forType: .string)
            if DeleteAfterCopyButton.state == .on
            {
                UUIDList.remove(at: Index)
                UUIDTable.reloadData()
            }
        }
    }
    
    @IBAction func HandleCreateButtonPressed(_ sender: Any)
    {
        let RawCount = UUIDCountField.stringValue
        if RawCount.isEmpty
        {
            print("No value for number of UUIDs specified.")
            return
        }
        if let RawValue = Int(RawCount)
        {
            if RawValue < 1
            {
                return
            }
            UUIDList.removeAll()
            for _ in 0 ..< RawValue
            {
                UUIDList.append(UUID())
            }
            UUIDTable.reloadData()
            return
        }
        print("Invalid number of UUIDs specified: \(RawCount)")
    }
    
    @IBAction func HandleClearButton(_ sender: Any)
    {
        UUIDList.removeAll()
        UUIDTable.reloadData()
    }
    
    @IBOutlet weak var DeleteAfterCopyButton: NSButton!
    @IBOutlet weak var UUIDTable: NSTableView!
    @IBOutlet weak var CreateButton: NSButton!
    @IBOutlet weak var ClearButton: NSButton!
    @IBOutlet weak var UUIDCountField: NSTextField!
}

