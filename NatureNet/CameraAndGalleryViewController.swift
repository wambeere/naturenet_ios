//
//  CameraAndGalleryViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/12/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import Photos

class CameraAndGalleryViewController: UIViewController ,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var imagesCollectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var selectButton: UIButton!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    //collection view
    private let options:PHFetchOptions = PHFetchOptions();
    private let leftAndRightPaddings: CGFloat = 4.0
    private let numberOfItemsPerRow: CGFloat = 4.0
    private let heightAdjust: CGFloat = 0.0
    var photos:PHFetchResult = PHFetchResult()
    let manager = PHImageManager.defaultManager()
    var width = CGFloat(0.0)
    var lastCellSelected = NSIndexPath()
    
    var selectedPhotoIndexPath : NSIndexPath? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        picker!.delegate=self
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        //need to get permission before actually grabbing
        if PHPhotoLibrary.authorizationStatus() != .Authorized{
            // If there is no permission for photos, ask for it
            print("not authorized")
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
            return
        }
        
        print("authorized")
        
        options.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        photos = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        
        let nib = UINib(nibName: "CameraAndGalleryCollectionViewCell", bundle: nil)
        imagesCollectionView.registerNib(nib, forCellWithReuseIdentifier: "ImageCell")
        
        width = (CGRectGetWidth(imagesCollectionView!.frame) - leftAndRightPaddings) / (numberOfItemsPerRow)
        let layout = imagesCollectionViewLayout as UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, width + heightAdjust)
        
        
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus)
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized
        {
            print("\nauthorized")
        }
        else
        {
            executeInMainQueue({ self.dismissViewControllerAnimated(true, completion: nil) })
        }
    }
    
    func executeInMainQueue(function: () -> Void)
    {
        dispatch_async(dispatch_get_main_queue(), function)
    }
    
    
    @IBAction func cameraButtonClicked(sender: UIButton) {
        
        self.openCamera()
        
    }
    @IBAction func galleryButtonClicked(sender: UIButton) {
        
        self.openGallary()
        
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        //imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        print(info[UIImagePickerControllerOriginalImage])
        
        let newObsVC = NewObsViewController()
        newObsVC.obsImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        let newObsNavVC = UINavigationController()
        newObsNavVC.viewControllers = [newObsVC]
        self.presentViewController(newObsNavVC, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        print("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == PHAuthorizationStatus.Authorized {
            let photoCount = photos.count
            if photoCount < 8 {
                return photoCount
            } else {
                return 8
            }
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! CameraAndGalleryCollectionViewCell
        let photo = photos.objectAtIndex(indexPath.item) as? PHAsset
        print(photo!)
        manager.requestImageForAsset(photo!, targetSize: CGSize(width: width, height: width), contentMode: .AspectFill, options: nil) { (result, _) in
            cell.imageView?.image = result
        }
        
        //if offscreen cells need to be made, there should be a check here to see whether the cell is selected or not
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CameraAndGalleryCollectionViewCell
        
        //allows user to deselect when clicking a currently selected cell
        if lastCellSelected == indexPath {
            cell.selected = false
            cell.imageView.layer.borderWidth = 0
            lastCellSelected = NSIndexPath()    //set this way to allow you to click this cell again after
            selectButton.hidden = true
        } else {
            cell.imageView.layer.borderWidth = 4
            cell.imageView.layer.borderColor = UIColor.yellowColor().CGColor
            lastCellSelected = indexPath
            selectButton.hidden = false
        }
        //print("selected \n\t\(indexPath)\n\t\(cell.selected)")
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CameraAndGalleryCollectionViewCell
        cell.imageView.layer.borderWidth = 0
        //print("deselected \n\t\(indexPath)\n\t\(cell.selected)")
    }
    
    @IBAction func selectButtonPressed(sender: AnyObject) {
        print("selected")
        let newObsVC = NewObsViewController()
        let photo = photos.objectAtIndex(lastCellSelected.item) as? PHAsset
        print("\(photo?.pixelHeight)h x \(photo?.pixelWidth)w")
        let imageOptions = PHImageRequestOptions()
        imageOptions.resizeMode = .None
        imageOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
        imageOptions.synchronous = true
        manager.requestImageForAsset(photo!, targetSize: CGSize(width: CGFloat((photo?.pixelWidth)!), height: CGFloat((photo?.pixelHeight)!)), contentMode: .AspectFit, options: imageOptions) { (result, _) in
            newObsVC.obsImage = result!
        }
        //newObsVC.obsImage = (cell.imageView?. as? UIImage)!
        let newObsNavVC = UINavigationController()
        newObsNavVC.viewControllers = [newObsVC]
        self.presentViewController(newObsNavVC, animated: true, completion: nil)
        
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
