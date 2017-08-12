//
//  ViewController.swift
//  iOS-UI-UIImage-Study
//
//  Created by duzhe on 2017/8/12.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//  underlying 底层
  
  
  @IBOutlet weak var imageView1: UIImageView!
  @IBOutlet weak var imageView2: UIImageView!
  @IBOutlet weak var imageView3: UIImageView!
  @IBOutlet weak var imageView4: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 尽管UIImage 支持多种格式的图片 ， 但是还是推荐使用 PNG 或者 JPEG , UIImage 对这两种格式做了优化，所有它的展示效果会比别的格式要好。因为PNG是无损格式的，也是苹果特别推荐的格式 。
    // 从Asset或者本地图片文件（在bundle中） 创建UIImage对象 init(named:) 和 init(named:in:compatibleWith:) 这两个方法会自动缓存image data , 也是苹果推荐的用法 。 加载一次后会缓存在内存，下次直接加载 ， 界面使用起来会比较流畅 。
//    let image = UIImage(named: <#T##String#>, in: <#T##Bundle?#>, compatibleWith: <#T##UITraitCollection?#>)
//    let image = UIImage(contentsOfFile: "xxx")
//    init(contentsOfFile:) 这个方法是通过本地文件但是不在bundle中去创建一个UIImage对象。 这个方法每次都会从本地加载图片，并不会缓存。尽量不要使用它来加载需要频繁使用的图片
    
//    UIImage.animatedImageNamed(<#T##name: String##String#>, duration: <#T##TimeInterval#>)
//    UIImage.animatedImage(with: <#T##[UIImage]#>, duration: <#T##TimeInterval#>)
    
//    let imageView = UIImageView()
//    imageView.animationImages
    
    let images = [
      UIImage(named: "鲸鱼")! ,
      UIImage(named: "考拉")!
    ]
    
    let image = UIImage.animatedImage(with: images, duration: 0.5)
    imageView1.image = image
    
    let image2 = UIImage.animatedImageNamed("动画", duration: 0.5)
    imageView2.image = image2
    
    imageView3.animationImages = images
    imageView3.animationDuration = 0.8
    imageView3.animationRepeatCount = 0 // 无限制 
    imageView3.startAnimating()
    
    // Defining a Stretchable Image
    let image4 = UIImage(named: "chat_sender_text_bg") // ?.stretchableImage(withLeftCapWidth: 4, topCapHeight: 25)
    let size = image4?.size ?? .zero
    
    imageView4.image = image4?.resizableImage(withCapInsets: UIEdgeInsetsMake(25, 4, size.height-24 , size.width-3) , resizingMode: UIImageResizingMode.tile)
    
    // Comparing Images
//    isEqual(_:) 是唯一可靠的方式判断两个UIImage是否有相同的image data 
    let cimage1 = UIImage(named: "考拉")
    let cimage2 = UIImage(named: "考拉")
    if let img1 = cimage1, let img2 = cimage2 {
      if img1.isEqual(img2){
        print("YES")
      }else{
        print("No")
      }
      let data = UIImagePNGRepresentation(img1)
      if let data2 = UIImageJPEGRepresentation(img1, 0.5) {
        print(data2.count/1000)
      }
    }
  }
  // 当然也可以用cgImage和 ciImage创建UIImage  
  
}



extension UIImage {
  
  //图像比例缩放
  public func scaleImage(_ img:UIImage,scaleSize:CGFloat)->UIImage{
    UIGraphicsBeginImageContext(CGSize(width: img.size.width * scaleSize, height: img.size.height * scaleSize))
    img.draw(in: CGRect(x: 0, y: 0, width: CGFloat( Int(img.size.width * scaleSize) + 1 ) , height: img.size.height * scaleSize + 1))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return scaledImage!
  }
  
  //自定长宽 可能会有拉伸
  public func reSizeImage(_ toSize:CGSize)->UIImage{
    UIGraphicsBeginImageContext(CGSize(width: toSize.width, height: toSize.height))
    self.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
    let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return reSizeImage!
  }
  
  
  
  /// 二分法压缩图片
  ///
  /// - Parameter toByte: byte大小
  /// - Returns: UIImage
  public func compressImageQuality(toByte:Double)-> UIImage?{
    var compression: CGFloat = 1.0
    if var data = UIImageJPEGRepresentation(self, compression) {
      let kbs = Double(data.count/1000)
      if kbs <= toByte {
        return self
      }
      var max: CGFloat = 1
      var min: CGFloat = 0
      
      // 最多7次
      for _ in 0...6 {
        compression = CGFloat((max+min)/2)
        data = UIImageJPEGRepresentation(self, compression)!
        let kbs = Double(data.count/1000)
        if kbs < toByte*0.9 {
          min = compression
        } else if kbs > toByte {
          max = compression
        } else {
          break
        }
      }
      
      let resultImage = UIImage(data: data)
      return resultImage
    }
    return nil
  }
  
}








































