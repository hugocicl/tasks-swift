//
//  AddViewController.swift
//  tasks
//
//  Created by Francisco Pronto on 08/09/2018.
//  Copyright © 2018 Francisco Pronto. All rights reserved.
//

import UIKit

class AddViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var titleTask: UITextField!
    @IBOutlet weak var stateTask: UIPickerView!
    @IBOutlet weak var dateTask: UITextField!
    @IBOutlet weak var descTask: UITextView!
    
    private var datePicker: UIDatePicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTask.inputView = datePicker

        
        dateTask.delegate = self
        titleTask.delegate = self
        
        stateTask.delegate=self
        stateTask.dataSource=self
        descTask.delegate = self
        // Do any additional setup after loading the view.
    }

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView.tag {
        case 0...1:
            break
        default:
            scrollView.setContentOffset(CGPoint(x:0.0,y:250.0), animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x:0.0,y:0.0), animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...1:
            break
        default:
            scrollView.setContentOffset(CGPoint(x:0.0,y:250.0), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0.0,y:0.0), animated: true)
    }
    func textFieldShouldReturn(_ textfield: UITextField)->Bool{
        if textfield.tag == 0{
            titleTask.becomeFirstResponder()
        }else if textfield.tag == 1 {
            dateTask.becomeFirstResponder()
        }else if textfield.tag == 2 {
            textfield.resignFirstResponder()
        }
        return true;
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTask.text=dateFormatter.string(from: datePicker.date)
    }
    
    let state = ["Not Done","Done", "Doing"]
    var selectedState = 0
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let maxLength = 200
        let currentString: NSString = descTask.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: currentString as String) as NSString
        return newString.length <= maxLength
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return state[row]
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return state.count
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedState = stateTask.selectedRow(inComponent: 0)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var userDefaults:UserDefaults = UserDefaults.standard
        var itemList:NSMutableArray? = userDefaults.object(forKey: "itemList") as? NSMutableArray
        
        if(titleTask.text != "")
        {
//            endDateTask.datePickerMode = UIDatePickerMode.date
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MMM yyyy"
//            let selectedDate = dateFormatter.string(from:endDateTask.date)
        
            let dataSet:NSMutableDictionary = NSMutableDictionary()
            dataSet.setObject(titleTask.text, forKey: "itemTitle" as NSCopying)
            dataSet.setObject(selectedState , forKey: "itemState" as NSCopying)
            dataSet.setObject(descTask.text, forKey: "itemDesc" as NSCopying)
            dataSet.setObject(dateTask.text, forKey: "itemDate" as NSCopying)
            
            if(itemList != nil){
                var nmList:NSMutableArray = NSMutableArray()
                for dict:Any in itemList!{
                    nmList.add(dict as! NSDictionary)
                }
                userDefaults.removeObject(forKey: "itemList")
                nmList.add(dataSet)
                userDefaults.set(nmList, forKey: "itemList")
                
            }else{
                userDefaults.removeObject(forKey: "itemList")
                itemList = NSMutableArray()
                itemList!.add(dataSet)
                userDefaults.set(itemList,forKey: "itemList")
            }
            UserDefaults.standard.synchronize()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
