node default {

  include 'cm::application'
  include 'cm::services'

  include 'janus'
  include 'janus::plugin::audioroom'
  include 'janus::plugin::rtpbroadcast'

}
