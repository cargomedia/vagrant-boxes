node default {

  include 'cm::application'
  class { 'cm::services':
    ssl_key => template("cm_ssl/wildcard.dev.cargomedia.ch.key"),
    ssl_cert => template("cm_ssl/wildcard.dev.cargomedia.ch.pem"),
  }
  include 'janus::common'
  include 'janus::common_rtpbroadcast'
  include 'janus::common_audioroom'
  include 'cm_janus::common'
}
