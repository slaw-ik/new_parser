# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@hide_panel = () ->
  if $(".tabbable").hasClass('showed')
    $(".tabbable").animate({"left": "+=315px"}, "slow").removeClass("showed")

@show_panel = () ->
  active_tab = $(this).hasClass('active')

  unless $(".tabbable").hasClass('showed')
    $(".tabbable").animate({"left": "-=315px"}, "slow").addClass("showed")
  else
    hide_panel() if active_tab

@build_from = (coord) ->
  $('#coord_from').val(coord)
  build($('#coord_from').val(), $('#coord_to').val())

@build_to = (coord) ->
  $('#coord_to').val(coord)
  build($('#coord_from').val(), $('#coord_to').val())

build = (from = null, to = null) ->
  if from && to
    $.get('get_direction_info?from=' + from + '&to=' + to, (data) ->
      modal.open({content: data}))

$ ->
  $body = $("body")

  $(document).on
    ajaxStart: ->
      $body.addClass("loading")
    ajaxStop: ->
      $body.removeClass("loading")

  $(".tabbable li").click ->
    show_panel()

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