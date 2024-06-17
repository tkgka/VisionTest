//
//  ImmersiveView.swift
//  VisionTest
//
//  Created by 김수환 on 2/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @ObservedObject var gestureModel: HeartGestureModel
    var body: some View {
        RealityView { content in
            
        } update: { _ in
            let handsCenterTransform = gestureModel.computeTransformOfUserPerformedHeartGesture()
            Task { @MainActor in
                gestureModel.leftHandSkeleton = handsCenterTransform.first ?? .neutralPose
                gestureModel.rightHandSkeleton = handsCenterTransform.last ?? .neutralPose
            }
        } .gesture(DragGesture(minimumDistance: 0.0)
            .targetedToAnyEntity()
            .onChanged { @MainActor drag in
                
            }
            .onEnded { dragEnd in
                
            }
        )
        .task {
            await gestureModel.start()
        }
        .task {
            await gestureModel.publishHandTrackingUpdates()
        }
        .task {
            await gestureModel.monitorSessionEvents()
        }
    }
}
