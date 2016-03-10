node default {

  include 'cm::application'
  include 'cm::services'
  include 'janus::common'
  include 'janus::common_rtpbroadcast'
  include 'janus::common_audioroom'
  include 'cm_janus::common'
}
