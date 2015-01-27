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
  var currentAutoIndex = 0
  
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
  }
  
  func socketDisconnected() {
  }
  
  func historyPlaylistUpdated(playlist: [PlaylistTrack]) {
    if(playlist.count > 0) {
      println("[\(playlist.count)] first track of history is \(playlist[0].name) #\(playlist[0].storeId)")
    }
    if(playlist.count > 10) {
      output?.didUpdateHistoryTracksList(playlist.slice(0,10).reverse())
    }
    else {
      output?.didUpdateHistoryTracksList(playlist.reverse())
    }
  }
  
  func requestPlaylistUpdated(playlist: [PlaylistTrack]) {
    self.requestPlaylist = playlist
    output?.didUpdateUpcomingPlaylist(makeUpcomingTrackList())
  }
  
  func autoPlaylistUpdated(playlist: [PlaylistTrack]) {
    self.autoPlaylist = playlist
    output?.didUpdateUpcomingPlaylist(makeUpcomingTrackList())
  }
  
  func nowPlayingUpdated(track: PlaylistTrack?, currentAutoIndex: Int?) {
    println("now playing updated \((track == nil)) track: \(track?.name)")
    if let index = currentAutoIndex {
      self.currentAutoIndex = index
      output?.didUpdateUpcomingPlaylist(makeUpcomingTrackList())
    }
    output?.didUpdateNowPlaying(track)
  }
  
  func makeUpcomingTrackList() -> [PlaylistTrack] {
    var auto = autoPlaylist
    var request = requestPlaylist
    
    if(autoPlaylist.count == self.currentAutoIndex + 1) {
      auto = []
    }
    if(autoPlaylist.count > self.currentAutoIndex + 1 && self.currentAutoIndex >= 0) {
      auto = auto.slice(self.currentAutoIndex + 1)
    }
    if(auto.count > 0 && output?.nowPlaying != nil && auto[0].fizyId == output?.nowPlaying?.fizyId && auto[0].fizyId != 0) {
      auto = auto.slice(1)
    }
    
    if(request.count > 0 && output?.nowPlaying != nil && request[0].fizyId == output?.nowPlaying?.fizyId) {
      println(request)
      request = request.slice(1)
      println(request)
    }
    return (request + auto)
  }
}
