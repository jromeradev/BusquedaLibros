//
//  Search.swift
//  BusquedaLibros
//
//  Created by Jose on 31/1/16.
//  Copyright © 2016 jromeradev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    let urlBase:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var autores: UITextView!
    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var search: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.search.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadBookData(isbn:String)throws->NSData? {
        let url = NSURL(string:urlBase+isbn)
        let datos:NSData? = try NSData(contentsOfURL:url!,options: NSDataReadingOptions.DataReadingMappedIfSafe)
        return datos
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        do{
            let datos:NSData? = try loadBookData(search.text!)
            if (datos != nil) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    if let mainjson = json as? NSDictionary{
                        if let main = mainjson["ISBN:"+search.text!] as? NSDictionary {
                            let titlejs = main["title"] as! NSString as String
                            titulo.text = titlejs
                            let autoresjs = main["authors"] as! NSArray
                            
                            if let coverMainjs = main["cover"] as? NSDictionary {
                                
                                let urlCoverjs = coverMainjs["medium"] as! NSString as String
                                let url = NSURL(string:urlCoverjs)
                                let dataImg = NSData(contentsOfURL: url!)
                                portada.image = UIImage(data:dataImg!)
                                
                            }
                            for autor in autoresjs {
                                autores.text = autores.text! + (autor["name"] as! NSString as String) + "\n"
                            }
                        }
                    }
                    
                    
                }catch let error as NSError {
                    let alerta = UIAlertController(title:"Error acceso datos", message: error.description, preferredStyle:.Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alerta.addAction(OKAction)
                    self.presentViewController(alerta, animated: true, completion: nil)
                }
                
            }
        } catch let error as NSError {
            let alerta = UIAlertController(title:"Error acceso URL", message: error.description, preferredStyle:.Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alerta.addAction(OKAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
