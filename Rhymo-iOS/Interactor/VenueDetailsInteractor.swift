//
//  VenueDetailsInteractor.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenueDetailsInteractor: BaseInteractor, RhymoSocketDelegate {
  
  var output: VenueDetailsPresenter?
  var socket: RhymoSocket?
  
  var venue: Venue?
  
  var autoPlaylist = [PlaylistTrack]()
  var requestPlaylist = [PlaylistTrack]()
  
  func getVenueDetails(venueId: Int, result: (error: NSError?, venue: Venue?) -> ()) {
    let client = RhymoClient()
    client.getVenueDetails(venueId, result: result)
  }
  
  func userInterfaceReady() {
    // TODO: Start Socket, Start Loading
    
    // set fake data
    output?.historyPlaylist = [PlaylistTrack]()
    output?.upcomingPlaylist = [PlaylistTrack]()
    
//    output?.updateNowPlaying()
//    output?.startProgress(nowPlaying)

    if let user = RhymoClient.getAuthenticatedUser() {
      if let venue = output?.venueDetailsWireframe?.venue {
        socket = RhymoSocket(userId: user.id, venueId: venue.id)
        socket!.delegate = self
        socket!.connect()
      }
    }
  }
  
  func userInterfaceWillHide() {
    socket?.disconnect()
  }
  
  func userInterfaceWillShowAgain() {
    socket?.connect()
  }
  
  // MARK: - Socket Delegation
  
  func socketConnected() {
    println("socket connected at interactor")
  }
  
  func socketDisconnected() {
    println("socket disconnected at interactor")
  }
  
  func historyPlaylistUpdated(playlist: [PlaylistTrack]) {
    println("history playlist updated")
    output?.didUpdateHistoryTracksList(playlist.reverse())
  }
  
  func requestPlaylistUpdated(playlist: [PlaylistTrack]) {
    println("request playlist updated")
    self.requestPlaylist = playlist
    output?.didUpdateUpcomingPlaylist(makeUpcomingTrackList())
  }
  
  func autoPlaylistUpdated(playlist: [PlaylistTrack]) {
    println("auto playlist updated")
    self.autoPlaylist = playlist
    output?.didUpdateUpcomingPlaylist(makeUpcomingTrackList())
  }
  
  func nowPlaylingUpdated(track: PlaylistTrack?) {
    println("now playing updated \((track == nil)) track: \(track?.name)")
    output?.didUpdateNowPlaying(track)
  }
  
  func makeUpcomingTrackList() -> [PlaylistTrack] {
    return (requestPlaylist + autoPlaylist)
  }
}
