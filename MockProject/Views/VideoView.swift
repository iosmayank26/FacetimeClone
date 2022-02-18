//
//  VideoView.swift
//  MockProject
//
//  Created by Jared Davidson on 11/6/21.
//

import Foundation
import SwiftUI
import HMSSDK

struct VideoView: UIViewRepresentable {
	var track: HMSVideoTrack

	func makeUIView(context: Context) -> HMSVideoView {
		let videoView = HMSVideoView()
		videoView.setVideoTrack(track)
		videoView.backgroundColor = UIColor.black
		return videoView
	}
	
	func updateUIView(_ videoView: HMSVideoView, context: Context) {
		videoView.setVideoTrack(track)
	}
}
