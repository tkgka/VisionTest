//
//  GuestureModel.swift
//  VisionTest
//
//  Created by 김수환 on 2/24/24.
//

import ARKit
import SwiftUI

/// A model that contains up-to-date hand coordinate information.
@MainActor
class HeartGestureModel: ObservableObject, @unchecked Sendable {
    let session = ARKitSession()
    var handTracking = HandTrackingProvider()
    @Published var leftHandSkeleton: HandSkeleton = .neutralPose
    @Published var rightHandSkeleton: HandSkeleton = .neutralPose
    @Published var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
    
    struct HandsUpdates {
        var left: HandAnchor?
        var right: HandAnchor?
    }
    
    func start() async {
        do {
            if HandTrackingProvider.isSupported {
                print("ARKitSession starting.")
                try await session.run([handTracking])
            }
        } catch {
            print("ARKitSession error:", error)
        }
    }
    
    func publishHandTrackingUpdates() async {
        for await update in handTracking.anchorUpdates {
            switch update.event {
            case .updated:
                let anchor = update.anchor
                print("Something Happened \(anchor)")
                // Publish updates only if the hand and the relevant joints are tracked.
                guard anchor.isTracked else { continue }
                
                // Update left hand info.
                if anchor.chirality == .left {
                    latestHandTracking.left = anchor
                } else if anchor.chirality == .right { // Update right hand info.
                    latestHandTracking.right = anchor
                }
            default:
                break
            }
        }
    }
    
    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(let type, let status):
                if type == .handTracking && status != .allowed {
                    // Stop the game, ask the user to grant hand tracking authorization again in Settings.
                }
            default:
                print("Session event \(event)")
            }
        }
    }
    
    /// Computes a transform representing the heart gesture performed by the user.
    ///
    /// - Returns:
    ///  * A right-handed transform for the heart gesture, where:
    ///     * The origin is in the center of the gesture
    ///     * The X axis is parallel to the vector from left thumb knuckle to right thumb knuckle
    ///     * The Y axis is parallel to the vector from right thumb tip to right index finger tip.
    ///  * `nil` if either of the hands isn't tracked or the user isn't performing a heart gesture
    ///  (the index fingers and thumbs of both hands need to touch).
    func computeTransformOfUserPerformedHeartGesture() -> [HandSkeleton] {
        // Get the latest hand anchors, return false if either of them isn't tracked.
        guard let leftHandAnchor = latestHandTracking.left,
              let rightHandAnchor = latestHandTracking.right,
              let leftHandSkeleton = leftHandAnchor.handSkeleton,
              let rightHandSkeleton = rightHandAnchor.handSkeleton,
              leftHandAnchor.isTracked, rightHandAnchor.isTracked else {
            return []
        }
        return [leftHandSkeleton, rightHandSkeleton]
    }
 
}

extension HandSkeleton: Equatable {
    public static func == (lhs: HandSkeleton, rhs: HandSkeleton) -> Bool {
        lhs.description != rhs.description
    }
}
