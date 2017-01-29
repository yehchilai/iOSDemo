//
//  LoginViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
        
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        configureUI()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Login
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        userDidTapView(self)
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            setUIEnabled(false)
            
            /*
                Steps for Authentication...
                https://www.themoviedb.org/documentation/api/sessions
                
                Step 1: Create a request token
                Step 2: Ask the user for permission via the API ("login")
                Step 3: Create a session ID
                
                Extra Steps...
                Step 4: Get the user id ;)
                Step 5: Go to the next view!            
            */
            getRequestToken()
        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MoviesTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: error display
    
    private func displayError(_ error: String) {
        print(error)
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            self.debugTextLabel.text = "Login Failed (Request Token)."
        }
    }
    
    // MARK: TheMovieDB
    
    private func getRequestToken() {
        
        /* TASK: Get a request token, then store it (appDelegate.requestToken) and login with the token */
        
        // if an error occurs, print it and re-enable the UI
        

        /* 1. Set the parameters */
        let methodParameters = [
            Constants.TMDBParameterKeys.ApiKey: Constants.TMDBParameterValues.ApiKey
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url: appDelegate.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/authentication/token/new"))
        
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else{
                self.displayError("There is a request error.")
                return
            }
            
            guard let code = (response as? HTTPURLResponse)?.statusCode, code >= 200 && code <= 299 else{
                self.displayError("The http response is not 2xx.")
                return
            }

            /* 5. Parse the data */
            
            guard let data = data else{
                self.displayError("There is no response data.")
                return
            }
            
            let parsedData:[String:AnyObject]!
            
            do{
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            }catch{
                self.displayError("Cannot parse Json file.")
                return
            }
            
            guard let token = parsedData[Constants.TMDBResponseKeys.RequestToken] as? String else{
                self.displayError("Ther is no key: \(Constants.TMDBResponseKeys.RequestToken)")
                return
            }
            /* 6. Use the data! */
            print("TOKEN: \(token)")
            self.appDelegate.requestToken = token
            self.loginWithToken(self.appDelegate.requestToken!)
        }

        /* 7. Start the request */
        task.resume()
    }
    
    private func loginWithToken(_ requestToken: String) {
        
        /* TASK: Login, then get a session id (Valiate request tokem) */
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.TMDBParameterKeys.ApiKey:Constants.TMDBParameterValues.ApiKey,
            Constants.TMDBParameterKeys.Username: self.usernameTextField.text!,
            Constants.TMDBParameterKeys.Password: self.passwordTextField.text!,
            Constants.TMDBParameterKeys.RequestToken: self.appDelegate.requestToken
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url: self.appDelegate.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/authentication/token/validate_with_login"))
        
        /* 4. Make the request */
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else{
                self.displayError("There was an error with your request: \(error)")
                return
            }
            
            guard let code = (response as? HTTPURLResponse)?.statusCode, code >= 200 && code <= 299 else{
                self.displayError("The http response code is NOT 2XX.")
                return
            }
            
            guard let data = data else{
                self.displayError("There is no returned data")
                return
            }
            /* 5. Parse the data */
            
            let parsedData:[String:AnyObject]!
            do{
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            }catch{
                self.displayError("Cannot parse data.")
                return
            }
            
            guard let success = parsedData[Constants.TMDBResponseKeys.Success] as? Bool, success == true else{
                self.displayError("Cannot find Key: \(Constants.TMDBResponseKeys.Success)")
                return
            }
            print("success: \(success)")
            /* 6. Use the data! */
            getSessionID(self.appDelegate.requestToken)
        }
        
        /* 7. Start the request */
        
        task.resume()
    }
    
    private func getSessionID(_ requestToken: String) {
        
        /* TASK: Get a session ID, then store it (appDelegate.sessionID) and get the user's id */
        
        /* 1. Set the parameters */
        /* 2/3. Build the URL, Configure the request */
        /* 4. Make the request */
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
    }
    
    private func getUserID(_ sessionID: String) {
        
        /* TASK: Get the user's ID, then store it (appDelegate.userID) for future use and go to next view! */
        
        /* 1. Set the parameters */
        /* 2/3. Build the URL, Configure the request */
        /* 4. Make the request */
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
            movieImageView.isHidden = true
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
            movieImageView.isHidden = false
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
    }
    
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = Constants.UI.GreyColor
        textField.textColor = Constants.UI.BlueColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.tintColor = Constants.UI.BlueColor
        textField.delegate = self
    }
}

// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
