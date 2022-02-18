//
//  FacetimeView.swift
//  MockProject
//
//  Created by Jared Davidson on 11/6/21.
//

import Foundation
import SwiftUI
import HMSSDK

struct FacetimeView: View {
	var hmsSDK = HMSSDK.build()
	@State var localTrack = HMSVideoTrack()
	@State var friendTrack = HMSVideoTrack()
	let tokenProvider = TokenProvider()
	@StateObject var viewModel: ViewModel
	@Environment(\.presentationMode) var presentationMode
	
	@State var isMuted: Bool = false
	@State var videoIsShowing: Bool = true
	
	
	
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			VideoView(track: friendTrack)
				.edgesIgnoringSafeArea(.all)
			if !videoIsShowing {
				ZStack {
					Color.gray
					Image(systemName: "video.slash.fill")
				}
				.frame(width: 150, height: 250, alignment: .center)
				.padding()
			} else {
				VideoView(track: localTrack)
					.frame(width: 150, height: 250, alignment: .center)
					.cornerRadius(10)
					.shadow(radius: 20)
					.padding(.bottom, 80)
					.padding()
			}
			videoOptions
				.padding(.bottom, 10)
		}
		.onAppear(perform: {
			joinRoom()
			listen()
		})
		.onDisappear(perform: {
			
		})
	}
	
	var videoOptions: some View {
		HStack(spacing: 20) {
			Spacer()
			Button {
				stopCamera()
			} label: {
				Image(systemName: videoIsShowing ? "video.fill" : "video.slash.fill")
					.frame(width: 60, height: 60, alignment: .center)
					.background(Color.white)
					.foregroundColor(Color.black)
					.clipShape(Circle())
			}
			
			Button {
				endRoom()
			} label: {
				Image(systemName: "phone.down.fill")
					.frame(width: 60, height: 60, alignment: .center)
					.background(Color.red)
					.foregroundColor(Color.white)
					.clipShape(Circle())
			}
			
			Button {
				muteMic()
			} label: {
				Image(systemName: isMuted ? "mic.slash.fill" : "mic.fill")
					.frame(width: 60, height: 60, alignment: .center)
					.background(Color.white)
					.foregroundColor(Color.black)
					.clipShape(Circle())
			}
			Spacer()
		}
	}
	
	func switchCamera() {
		self.hmsSDK.localPeer?.localVideoTrack()?.switchCamera()
	}
	
	func muteMic() {
		if isMuted {
			self.hmsSDK.localPeer?.localAudioTrack()?.setMute(true)
		} else {
			self.hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
		}
		isMuted.toggle()
	}
	
	func stopCamera() {
		if self.videoIsShowing {
			self.hmsSDK.localPeer?.localVideoTrack()?.stopCapturing()
			self.videoIsShowing = false
		} else {
			self.hmsSDK.localPeer?.localVideoTrack()?.startCapturing()
			self.videoIsShowing = true
		}
	}
	
	func endRoom() {
		hmsSDK.endRoom(lock: false, reason: "Meeting has ended") { didEnd, error in
			if didEnd {
				self.presentationMode.wrappedValue.dismiss()
			} else {
				
			}
		}
	}
	
	func listen() {
		self.viewModel.addVideoView = {
			track in
			hmsSDK.localPeer?.localAudioTrack()?.setMute(false)
			hmsSDK.localPeer?.localVideoTrack()?.startCapturing()
			self.localTrack = hmsSDK.localPeer?.localVideoTrack() as! HMSVideoTrack
			self.friendTrack = track
		}
		
		self.viewModel.removeVideoView = {
			track in
			self.friendTrack = track
		}
	}
	
	
	func joinRoom() {
		tokenProvider.getToken(for: "6186d0e8be6c3c0b3514ff6b", role: "host", completion: {
			token, error in
			let config = HMSConfig(authToken: token ?? "")
			hmsSDK.join(config: config, delegate: self.viewModel)
		})
	}
}

extension FacetimeView {
	class ViewModel: ObservableObject, HMSUpdateListener {
		
		@Published var addVideoView: ((_ videoView: HMSVideoTrack) -> ())?
		@Published var removeVideoView: ((_ videoView: HMSVideoTrack) -> ())?
		
		func on(join room: HMSRoom) {
			
		}
		
		func on(room: HMSRoom, update: HMSRoomUpdate) {
			
		}
		
		func on(peer: HMSPeer, update: HMSPeerUpdate) {
			
		}
		
		func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
			switch update {
			case .trackAdded:
				if let videoTrack = track as? HMSVideoTrack {
					addVideoView?(videoTrack)
				}
			case .trackRemoved:
				if let videoTrack = track as? HMSVideoTrack {
					removeVideoView?(videoTrack)
				}
			default:
				break
			}
		}
		
		func on(error: HMSError) {
			
		}
		
		func on(message: HMSMessage) {
			
		}
		
		func on(updated speakers: [HMSSpeaker]) {
			
		}
		
		func onReconnecting() {
			
		}
		
		func onReconnected() {
			
		}
		
	}
}
