window.TeamDirectory =
  team: []
  filters: null
  init: ->
    # Save the team members for a quick lookup
    TeamDirectory.team = $('div.team-listing div.node').hide()

    TeamDirectory.filters = $('div.team-directory-filters ul.dropdown-menu a');
    TeamDirectory.filters.click (e) ->
      $this = $(this);
      e.preventDefault()
      tid = $this.data('team')
      $this.parents('.dropdown-menu').find('a').removeClass('current active');
      $this.addClass('current active');
      
      TeamDirectory.filterByTeam(tid)

    # Show the first team on load
    TeamDirectory.filters.filter('.current').trigger('click')

  filterByTeam: (tid) ->
    if tid is "all"
      TeamDirectory.team.show()
    else
      TeamDirectory.team.hide().filter('.team-'+tid).show()

$(document).ready(TeamDirectory.init)