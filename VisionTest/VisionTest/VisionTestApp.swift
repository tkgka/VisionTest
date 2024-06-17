//
//  VisionTestApp.swift
//  VisionTest
//
//  Created by 김수환 on 2/24/24.
//

import SwiftUI

@main
struct VisionTestApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(gestureModel: HeartGestureModelContainer.heartGestureModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}


@MainActor
enum HeartGestureModelContainer {
    private(set) static var heartGestureModel = HeartGestureModel()
}
