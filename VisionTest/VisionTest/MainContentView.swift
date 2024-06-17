//
//  MainContentView.swift
//  VisionTest
//
//  Created by 김수환 on 3/3/24.
//

import SwiftUI

struct MainContentView: View {
    let leftImage: CGImage = UIImage(named: "stereo_left")!.cgImage!
    let rightImage: CGImage = UIImage(named: "stereo_left")!.cgImage!
    var body: some View {
        HStack {
            Image(uiImage: UIImage(cgImage: leftImage))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            Image("result.HEIC")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            Image(uiImage: UIImage(cgImage: rightImage))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)

            Image(
                uiImage: PicCombiner().combineImages(
                    leftImg: UIImage(named: "stereo_left")!.cgImage!,
                    rightImg: UIImage(named: "stereo_left")!.cgImage!
                )!
            )
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
        }
    }
}

#Preview {
    MainContentView()
}
