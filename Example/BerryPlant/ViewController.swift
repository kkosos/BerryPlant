//
//  ViewController.swift
//  Berry
//
//  Created by czqasngit on 07/11/2018.
//  Copyright (c) 2018 czqasngit. All rights reserved.
//

import UIKit
import BerryPlant

class WebPDecoder: WebPDecoderProtocol {
    func getWebPInfo(_ data: Data) -> (width: Int32, height: Int32) {
        let bytes = data.copyAllBytes()
        var _width: Int32 = 0
        var _height: Int32 = 0
        WebPGetInfo(bytes, data.count, &_width, &_height)
        return (_width, _height)
    }
    
    func decodeWebP(_ data: Data, width: inout Int32, height: inout Int32) -> UnsafeMutablePointer<UInt8>? {
        let bytes = data.copyAllBytes()
        return WebPDecodeRGBA(bytes, data.count, &width, &height)
    }
    
    func decodeComplete(_ context: UnsafeMutableRawPointer?) {
        context?.deallocate()
    }
}
class ViewController: UIViewController {

    var imageView: BerryAnimateImageView!
    var data: Data!
    var webpDecoderImpl = WebPDecoder()
    public func configure(with data: Data) {
        self.data = data
    }
    deinit {
        print("ViewController deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        WebPDecoderImplManager.shared.registerWebPDecoderImpl(webpDecoderImpl)
        setup()
    }
    
    func setup(){
        self.imageView = BerryAnimateImageView(data, frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 300), cache: BerryAnimateImageView.Policy.noCache)
        self.view.addSubview(self.imageView)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.animationRepeatCount = 0
        
    }
    
    
    
    
    @IBAction func start(sender: UIButton) {
        guard !self.imageView._isAnimating else { return }
        self.imageView.startAnimating()
    }
}

