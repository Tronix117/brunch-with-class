module.exports = class NavPagerItemView extends View

  makeInactive: (transition = 'fadeOut')->
    @$('.active-tab').velocity 'transition.' + transition, 500

  makeActive: (transition = 'fadeIn')->
    @$('.active-tab').velocity 'transition.' + transition, 500

  go: => @$('a').click()