# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@buildMapFromMarkers = (json_markers) ->
  provider = {}
  if json_markers.length == 1
    provider.zoom = 15
    provider.center = new google.maps.LatLng(json_markers[0].lat, json_markers[0].lng)
    provider.mapTypeId = google.maps.MapTypeId.HYBRID

  window.mapHandler = Gmaps.build("Google")
  window.mapHandler.buildMap
    provider: provider
    internal:
      id: "map"
  , ->
    markers = window.mapHandler.addMarkers(json_markers)
    window.mapHandler.bounds.extendWith markers
    if json_markers.length != 1
      window.mapHandler.fitMapToBounds()
    return


@hide_panel = () ->
  if $(".tabbable").hasClass('showed')
    $(".tabbable").animate({"left": "+=315px"}, "slow").removeClass("showed")

@show_panel = (identifier = null) ->
  if typeof identifier == "number"
    $('.tabbable li a').eq(identifier).tab('show')
  else
    if typeof identifier == "object" && identifier != null
      active_tab = $(identifier).hasClass('active')

  unless $(".tabbable").hasClass('showed')
    $(".tabbable").animate({"left": "-=315px"}, "slow").addClass("showed")
  else
    hide_panel() if active_tab

@build_from = (coord) ->
  $('#input-from').val(coord)
  show_panel(2)
  build($('#input-from').val(), $('#input-to').val())

@build_to = (coord) ->
  $('#input-to').val(coord)
  show_panel(2)
  build($('#input-from').val(), $('#input-to').val())

build = (from = null, to = null) ->
  Gmaps.Google.Builders.Marker.CURRENT_INFOWINDOW.close()
  if from && to
    $.get("#{window.location.protocol}//#{window.location.host}/get_direction_info?from=#{from}&to=#{to}", (data) ->
    )


@clear_directions_data = ->
  directionsDisplay.setMap(null) if (typeof directionsDisplay != 'undefined')
  $('#input-from').val("")
  $('#input-to').val("")
  $('#directions-panel').html("")
  hide_panel()
  $('.tabbable li a').eq(0).tab('show')

$ ->
  $body = $("body")

  $(document).on
    ajaxStart: ->
      $body.addClass("loading")
    ajaxStop: ->
      $body.removeClass("loading")

  $(".tabbable li").click ->
    show_panel(this)

  $('#header-search-form i.icon-remove').click ->
    $('#header-search-form .input-medium').val('')

  #  $('input.input-medium.search-query').keypress = (e) ->
  #    if e.which == 13
  #      e.preventDefault()
  #      console.log e


  $(".form-search").submit ->
    valuesToSubmit = $(this).serialize()
    $.ajax(
      url: $(this).attr("action")
      data: valuesToSubmit
      dataType: "script"
    )
    false

  $("body").on "click", "#top_search", (event) ->
    if $('.wrapper').data('map')
      $("#top_slider").val("slider")

  $("body").on "click", "a.ajax_map", (event) ->
    if $('.wrapper').data('map')
      event.preventDefault()
      url = $(this).attr('href')
      $.ajax(
        url: url
        dataType: "script"
      )