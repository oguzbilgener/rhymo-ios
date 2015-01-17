//
//  VenueDetailsInteractor.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenueDetailsInteractor: BaseInteractor {
  
  var output: VenueDetailsPresenter?
  
  func getVenueDetails(venueId: Int, result: (error: NSError?, venue: Venue?) -> ()) {
    let client = RhymoClient()
    client.getVenueDetails(venueId, result: result)
  }
  
  func userInterfaceReady() {
    // TODO: Start Socket, Start Loading
    
    // set fake data
    output?.historyPlaylist = [PlaylistTrack]()
    output?.upcomingPlaylist = [PlaylistTrack]()
    
    let nowPlaying = PlaylistTrack()
    nowPlaying.name = "Fly Me To The Moon"
    nowPlaying.artistName = "Frank Sinatra"
    nowPlaying.albumName = "Best of The Best"
    nowPlaying.albumCoverUrl = "http://server2.oguzdev.com/file/B005HR04HK.01_SL75_.jpg"
    output?.nowPlaying = nowPlaying
    
    let maggie = PlaylistTrack()
    maggie.name = "The Adventures of Rain Dance Maggie"
    maggie.artistName = "Red Hot Chili Peppers"
    maggie.albumName = "I'm With You"
    maggie.albumCoverUrl = "http://server2.oguzdev.com/file/RHCP_I'm_With_You_Cover.jpg"
    output?.historyPlaylist?.append(maggie)
    
    let rol = PlaylistTrack()
    rol.name = "Monkey Man"
    rol.artistName = "The Rolling Stones"
    rol.albumName = "Let It Bleed"
    rol.albumCoverUrl = "http://server2.oguzdev.com/file/LetitbleedRS.jpg"
    output?.upcomingPlaylist?.append(rol)
    
    output?.updateNowPlaying()
    output?.updateTracksList()
  }
}
