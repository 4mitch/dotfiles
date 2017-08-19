command: """
  IFS='|' read -r theArtist theName <<<"$(osascript <<<'tell application "Spotify"
          set theTrack to current track
          set theArtist to artist of theTrack
          set theName to name of theTrack
          return theArtist & "|" & theName
      end tell')"
  echo "$theArtist - $theName"
"""

refreshFrequency: 5000

render: -> """
  <i class='fa fa-spotify'></i>
  <span class="amount"></span>
"""

style: """
  left: 0px
"""

update: (output, el) ->
  $(el).find(".amount").text output
