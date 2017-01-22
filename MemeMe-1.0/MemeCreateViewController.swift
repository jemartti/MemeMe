//
//  MemeCreateViewController.swift
//  MemeMe-1.0
//
//  Created by Jacob Marttinen on 9/17/16.
//  Copyright © 2016 Jacob Marttinen. All rights reserved.
//

import UIKit

// MARK: - MemeCreateViewController: UIViewController

class MemeCreateViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraRollButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up top/bottom text attributes
        defineTextFieldAttributesOn(topLabel, attributes: memeTextAttributes)
        defineTextFieldAttributesOn(bottomLabel, attributes: memeTextAttributes)
        
        // Set up initial UI state
        shareButton.isEnabled = false
        cancelButton.isEnabled = true
        topLabel.text = "TOP"
        bottomLabel.text = "BOTTOM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        subscribeToKeyboardNotifications()
        
        // Set up app life cycle UI state
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: Life Cycle Supporting Functions
    
    // Defines Impact(ish) font, white with a black outline, size 40
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: Float(-3.0)
    ] as [String: Any]
    
    // Sets a TextField to have the lovely Impact(ish) formatting
    func defineTextFieldAttributesOn(_ textField: UITextField, attributes: [String: Any]) {
        textField.delegate = self
        textField.defaultTextAttributes = attributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_: )),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_: )),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    
    // MARK: Image Picker: Actions
    
    // Displays the photo picker
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        // Determine whether we want to display the camera or the album picker
        if sender == cameraRollButton {
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else if sender == cameraButton {
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
        }
        
        present(pickerController, animated: true, completion: nil)
    }
    
    
    // MARK: Meme: UI Actions
    
    func generateMemedImage() -> UIImage {
        // Hide UI elements
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show UI elements
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    
    // MARK: Share: Actions	
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        // Render the Meme
        let memedImage = generateMemedImage()
        
        // Load the Activity view
        let shareController = UIActivityViewController(
            activityItems: [memedImage],
            applicationActivities: nil
        )
        shareController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                // We know original image exists because share button wouldn't be active
                self.save(
                    topText: self.topLabel.text!,
                    bottomText: self.bottomLabel.text!,
                    originalImage: self.imagePickerView.image!,
                    memedImage: memedImage
                )
            }
        }
        
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        returnToRoot()
    }
    
    // save takes in the information defining a Meme and saves it
    func save(
        topText: String,
        bottomText: String,
        originalImage: UIImage,
        memedImage: UIImage
    ) {
        let meme = Meme(
            topText: topText,
            bottomText: bottomText,
            originalImage: originalImage,
            memedImage: memedImage
        )
        
        // Add it to the memes array on the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        returnToRoot()
    }
    
    // returnToRoot returns to the Sent Memes view
    func returnToRoot() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Keyboard visibility
    
    // If we're editing the bottom label, we want to slide the view out of the way
    // This way, we don't obstruct the field we're editing
    func keyboardWillShow(_ notification: NSNotification) {
        if bottomLabel.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    // Every time the keyboard hides, reset the view position
    func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // Calculates the height of the keyboard for the current device
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue
        return keyboardSize.cgRectValue.height
    }
}


// MARK: - MemeCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MemeCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String: Any]
    ) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // If we were given a valid image, display it
            imagePickerView.image = image
            
            // Hurrah! We can share it now!
            shareButton.isEnabled = true
            
            // Clean up the UI state
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Clean up the UI state
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - MemeCreateViewController: UITextFieldDelegate

extension MemeCreateViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear the text fields if they contain only default text
        if (textField == topLabel && textField.text == "TOP") ||
           (textField == bottomLabel && textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Cleanup the UI state
        textField.resignFirstResponder()
        return true
    }
}
