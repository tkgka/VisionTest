//
//  3DImageConverter.swift
//  VisionTest
//
//  Created by 김수환 on 3/3/24.
//

import SwiftUI
import AVFoundation
import UniformTypeIdentifiers
import ArgumentParser

let path = "JGXMYT9N0L"

struct PicCombiner: ParsableCommand {
    
    func combineImages(leftImg: CGImage, rightImg: CGImage) -> UIImage? {
        let imageWidth = CGFloat(leftImg.width)
        let imageHeight = CGFloat(leftImg.height)
        let totalWidth = imageWidth * 2
        let totalHeight = imageHeight
        
        UIGraphicsBeginImageContext(CGSize(width: totalWidth, height: totalHeight))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let leftImageRect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        let rightImageRect = CGRect(x: imageWidth, y: 0, width: imageWidth, height: imageHeight)
        
        context.draw(leftImg, in: leftImageRect)
        context.draw(rightImg, in: rightImageRect)
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
    
    func combineImages2(leftImg: CGImage, rightImg: CGImage, outputPath: String) {
        let newImageURL = URL(fileURLWithPath: outputPath)
        let destination = CGImageDestinationCreateWithURL(newImageURL as CFURL, UTType.heic.identifier as CFString, 2, nil)!
        
        let imageWidth = CGFloat(leftImg.width)
        let imageHeight = CGFloat(leftImg.height)
        let fovHorizontalDegrees: CGFloat = 55
        let fovHorizontalRadians = fovHorizontalDegrees * (.pi / 180)
        let focalLengthPixels = 0.5 * imageWidth / tan(0.5 * fovHorizontalRadians)
        let baseline = 65.0 // in millimeters

        let cameraIntrinsics: [CGFloat] = [
            focalLengthPixels, 0, imageWidth / 2,
            0, focalLengthPixels, imageHeight / 2,
            0, 0, 1
        ]

        let properties = [
            kCGImagePropertyGroups: [
                kCGImagePropertyGroupIndex: 0,
                kCGImagePropertyGroupType: kCGImagePropertyGroupTypeStereoPair,
                kCGImagePropertyGroupImageIndexLeft: 0,
                kCGImagePropertyGroupImageIndexRight: 1,
            ],
            kCGImagePropertyHEIFDictionary: [
                kIIOMetadata_CameraModelKey: [
                    kIIOCameraModel_Intrinsics: cameraIntrinsics as CFArray
                ]
            ]
        ]

        CGImageDestinationAddImage(destination, leftImg, properties as CFDictionary)
        CGImageDestinationAddImage(destination, rightImg, properties as CFDictionary)
        CGImageDestinationFinalize(destination)
    }
}


