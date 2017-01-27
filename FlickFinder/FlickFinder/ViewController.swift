//
//  ViewController.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {
    
    // MARK: Properties
    
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var phraseSearchButton: UIButton!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latLonSearchButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phraseTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Search Actions
    
    @IBAction func searchByPhrase(_ sender: AnyObject) {

        userDidTapView(self)
        setUIEnabled(false)
        
        if !phraseTextField.text!.isEmpty {
            photoTitleLabel.text = "Searching..."
            // TODO: Set necessary parameters!
            let methodParameters: [String: AnyObject] = [
                Constants.FlickrParameterKeys.SafeSearch:Constants.FlickrParameterValues.UseSafeSearch as AnyObject,
                Constants.FlickrParameterKeys.Text:phraseTextField.text as AnyObject,
                Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL as AnyObject,
                Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey as AnyObject,
                Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.SearchMethod as AnyObject,
                Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat as AnyObject,
                Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.DisableJSONCallback as AnyObject
            ]
            
            displayImageFromFlickrBySearch(methodParameters)
        } else {
            setUIEnabled(true)
            photoTitleLabel.text = "Phrase Empty."
        }
    }
    
    @IBAction func searchByLatLon(_ sender: AnyObject) {

        userDidTapView(self)
        setUIEnabled(false)
        
        if isTextFieldValid(latitudeTextField, forRange: Constants.Flickr.SearchLatRange) && isTextFieldValid(longitudeTextField, forRange: Constants.Flickr.SearchLonRange) {
            photoTitleLabel.text = "Searching..."
            // TODO: Set necessary parameters!
            let methodParameters: [String: AnyObject] = [
                Constants.FlickrParameterKeys.SafeSearch:Constants.FlickrParameterValues.UseSafeSearch as AnyObject,
                Constants.FlickrParameterKeys.BoundingBox:bboxString(lonStr: longitudeTextField.text!, latStr: latitudeTextField.text!) as AnyObject,
                Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL as AnyObject,
                Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey as AnyObject,
                Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.SearchMethod as AnyObject,
                Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat as AnyObject,
                Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.DisableJSONCallback as AnyObject
            ]

            displayImageFromFlickrBySearch(methodParameters)
        }
        else {
            setUIEnabled(true)
            photoTitleLabel.text = "Lat should be [-90, 90].\nLon should be [-180, 180]."
        }
    }
    
    private func bboxString(lonStr:String, latStr: String)-> String{
        guard let lon = Double(lonStr), let lat = Double(latStr) else{
            print("lat and lon are not numbers.")
            return "0,0,0,0"
        }
        let lonMin = max(lon - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let lonMax = min(lon + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let latMin = max(lat - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let latMax = min(lat + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
        
        
        return "\(lonMin),\(latMin),\(lonMax),\(latMax)"
    }
    
    // MARK: Flickr API
    
    private func displayImageFromFlickrBySearch(_ methodParameters: [String: AnyObject]) {
        
        print(flickrURLFromParameters(methodParameters))
        
        /*
        // TODO: Make request to Flickr!
        let parameters = [
            Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.GalleryPhotosMethod,
            Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.GalleryID:Constants.FlickrParameterValues.GalleryID,
            Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.DisableJSONCallback
        ]
        let urlString = "\(Constants.Flickr.APIBaseURL)" + escapedParameters(parameters: parameters as [String : AnyObject])
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                }
            }
            // GUARD: Check if there is an error
            guard error == nil else{
                displayError("There is an error:")
                return
            }
            // GUARD: Check the response status code
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 299 else{
                print("Status code is other than 2XX")
                return
            }
            
            // GUARD: Check if data is available
            guard let data = data else{
                print("No data was return")
                return
            }
            
            let parsedData:[String:AnyObject]!
            do{
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            }catch{
                displayError("Cannot parse data.")
                return
            }

            // GUARD: Check if the Flickr return OK response
            guard let statusFlickr = parsedData[Constants.FlickrResponseKeys.Status] as? String, statusFlickr == Constants.FlickrResponseValues.OKStatus else{
                print("Flickr did not return OK status.")
                return
            }
            
            // GUARD: Check if there is a photo dictionary in the json
            guard let photoDictionary = parsedData[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject] else{
                print("There is no photo dictionary")
                return
            }
            
            // GUARD: Check if there is an phtoo array in the json
            guard let photoArray = photoDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else{
                print("There is no Photos array")
                return
            }
            
            let randomNumber = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoInfo = photoArray[randomNumber] as [String: AnyObject]
            
            // GUARD: Is there "url_m" and "title" in the json
            guard let imageUrlStr = photoInfo[Constants.FlickrResponseKeys.MediumURL] as? String, let title = photoInfo[Constants.FlickrResponseKeys.Title] as? String else{
                print()
                return
            }
            
            
            let imageUrl = URL(string: imageUrlStr)
            
            if let imageData = try? Data(contentsOf: imageUrl!){
                
                let image = UIImage(data: imageData)
                performUIUpdatesOnMain {
                    self.photoImageView.image = image
                    self.photoTitleLabel.text = title
                    self.setUIEnabled(true)
                }
            }
        }
        
        task.resume()
        */
    }
    
    // Convert parameters to be able to send a url request
    private func escapedParameters(parameters: [String:AnyObject])-> String{
        
        if parameters.isEmpty{
            return ""
        }else{
            var keyValues = [String]()
            
            for (key, value) in parameters{
                let valueString = "\(value)"
                let escapedValueString = valueString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let kv = key + "=" + "\(escapedValueString!)"
                keyValues.append(kv)
            }
            
            return "?" + "\(keyValues.joined(separator: "&"))"
        }
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func flickrURLFromParameters(_ parameters: [String: AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}

// MARK: - ViewController: UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(phraseTextField)
        resignIfFirstResponder(latitudeTextField)
        resignIfFirstResponder(longitudeTextField)
    }
    
    // MARK: TextField Validation
    
    func isTextFieldValid(_ textField: UITextField, forRange: (Double, Double)) -> Bool {
        if let value = Double(textField.text!), !textField.text!.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    func isValueInRange(_ value: Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    }
}

// MARK: - ViewController (Configure UI)

private extension ViewController {
    
     func setUIEnabled(_ enabled: Bool) {
        photoTitleLabel.isEnabled = enabled
        phraseTextField.isEnabled = enabled
        latitudeTextField.isEnabled = enabled
        longitudeTextField.isEnabled = enabled
        phraseSearchButton.isEnabled = enabled
        latLonSearchButton.isEnabled = enabled
        
        // adjust search button alphas
        if enabled {
            phraseSearchButton.alpha = 1.0
            latLonSearchButton.alpha = 1.0
        } else {
            phraseSearchButton.alpha = 0.5
            latLonSearchButton.alpha = 0.5
        }
    }
}

// MARK: - ViewController (Notifications)

private extension ViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
