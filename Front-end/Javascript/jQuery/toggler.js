
/**
 *  Toggler
 *  State change
 *  Show / hide content by clicking on matching elements
 *  
 *  @example with <a>
 *      JS : $('a[data-toggler]').toggler();
 *      HTML : <a class="is-off" href="#target-by-id" aria-haspopup="true" aria-controls="target-by-id" data-toggler>...</a>
 *      <div class="is-off" id="target-by-id">...</div>
 *  @example variant with <button>
 *      JS : $('[aria-controls]').toggler();
 *      HTML : <button class="is-off" aria-haspopup="true" aria-controls="target-by-id">...</button>
 *  @example with custom callback (2 arguments : clicked element, and toggle target)
 *      JS : $('a[data-toggler]').toggler({ "callback": my_custom_callback_function });
 *      function my_custom_callback_function($clicked_element, $toggle_target) {  }
 *  
 *  W3C Recommendation WAI-ARIA references :
 *  @see http://www.w3.org/TR/wai-aria/states_and_properties#aria-controls
 *  @see http://www.w3.org/TR/wai-aria/states_and_properties#aria-haspopup
 */
jQuery.fn.toggler = function(options)
{
    $ = jQuery;
    
    //      For inner iteration
    //      @see several triggers for single target
    var $triggers = $(this);
    
    $triggers.each(function()
    {
        var $this = $(this),
            href = $this.attr('href'),
            target_selector = href ? href : '#' + $this.attr('aria-controls'),
            $target = target_selector ? $(target_selector) : {};
        
        if ($target.length)
        {
            //      Keep as data on toggle for later access
            $this.data('toggle_controls', $target);
            
            //      Handle several triggers for single target
            var extra_triggers = [];
            
            //      Reference all other triggers (except itself)
            $triggers.each(function()
            {
                var $iterated_trigger = $(this);
                if ($iterated_trigger.attr('href') == href && $iterated_trigger[0] !== $this[0]) {
                    extra_triggers.push($iterated_trigger);
                }
            });
            
            //      Keep these refs on itself
            if (extra_triggers && extra_triggers.length) {
                $this.data('extra_triggers', extra_triggers);
            }
            
            //      Single on, see below
            $this.data('triggers', $triggers);
            
            
            /**
             *  Click on toggle
             *  @todo refacto : fire customizable events
             */
            $this.click(function(e)
            {
                var $clicked_element = $(this),
                    $toggle_target = $clicked_element.data('toggle_controls'),
                    current_extra_triggers = $clicked_element.data('extra_triggers');
                
                //      Prevent default link behaviour unless allowed in options
                if (!options || !options.no_prevent_default) {
                    e.preventDefault();
                }
                
                if ($target.length)
                {
                    $toggle_target.toggleClass('is-off').toggleClass('is-on');
                    $clicked_element.toggleClass('is-off').toggleClass('is-on');
                    
                    //      Update other "triggers" pointing to the same target
                    if (current_extra_triggers && current_extra_triggers.length)
                    {
                        var i = 0,
                            max = current_extra_triggers.length;
                        for (i = 0; i < max; i++)
                        {
                            var $extra_trigger = current_extra_triggers[i];
                            
                            $extra_trigger.toggleClass('is-off').toggleClass('is-on');
                            
                            //      Extra triggers should only have 'aria-expanded'
                            var aria_expanded = $extra_trigger.attr('aria-expanded');
                            if (aria_expanded)
                            {
                                aria_expanded == 'true' ?
                                    $extra_trigger.attr('aria-expanded', 'false') :
                                    $extra_trigger.attr('aria-expanded', 'true') ;
                            }
                        };
                    }
                    
                    //      Accessibility : toggle attribute aria-hidden
                    //      http://www.w3.org/TR/wai-aria/states_and_properties#aria-hidden
                    var aria_hidden = $toggle_target.attr('aria-hidden');
                    if (aria_hidden)
                    {
                        aria_hidden == 'true' ?
                            $toggle_target.attr('aria-hidden', 'false') :
                            $toggle_target.attr('aria-hidden', 'true') ;
                    }
                    
                    //      Accessibility : toggle attribute aria-expanded
                    //      http://www.w3.org/TR/wai-aria/states_and_properties#aria-expanded
                    var aria_expanded = $clicked_element.attr('aria-expanded');
                    if (aria_expanded)
                    {
                        aria_expanded == 'true' ?
                            $clicked_element.attr('aria-expanded', 'false') :
                            $clicked_element.attr('aria-expanded', 'true') ;
                    }
                    
                    
                    //      Single on option (default + option to disable) :
                    //      allows to keep only one trigger(s)/target(s) pair active at a time (in current set of triggers),
                    //      essentially behaving like radios or tabs
                    //      @todo refacto : reuse same method in plugin
                    if (!options || !options.no_single_on)
                    {
                        $this.data('triggers').each(function()
                        {
                            
                            var $this_single_on = $(this),
                                this_single_on_href = $this_single_on.attr('href'),
                                this_single_on_target_selector = this_single_on_href ? this_single_on_href : '#' + $this_single_on.attr('aria-controls'),
                                clicked_element_href = $clicked_element.attr('href'),
                                clicked_element_target_selector = clicked_element_href ? clicked_element_href : '#' + $clicked_element.attr('aria-controls');

                            if (this_single_on_target_selector != clicked_element_target_selector && $this_single_on.hasClass('is-on'))
                            {
                                //      @todo method in plugin for that
                                var $target = $this_single_on.data('toggle_controls'),
                                    extra_triggers = $this_single_on.data('extra_triggers'),
                                    single_on_extra_triggers = $this_single_on.data('extra_triggers');
                                
                                if ($target.length)
                                {
                                    $target.toggleClass('is-off').toggleClass('is-on');
                                    $this_single_on.toggleClass('is-off').toggleClass('is-on');
                                    
                                    if (single_on_extra_triggers && single_on_extra_triggers.length)
                                    {
                                        var i = 0,
                                            max = single_on_extra_triggers.length;
                                        for (i = 0; i < max; i++)
                                        {
                                            var $extra_trigger = single_on_extra_triggers[i],
                                                aria_expanded = $extra_trigger.attr('aria-expanded');
                                            
                                            $extra_trigger.toggleClass('is-off').toggleClass('is-on');
                                            
                                            if (aria_expanded)
                                            {
                                                aria_expanded == 'true' ?
                                                    $extra_trigger.attr('aria-expanded', 'false') :
                                                    $extra_trigger.attr('aria-expanded', 'true') ;
                                            }
                                        }
                                    }
                                    
                                    var aria_hidden = $target.attr('aria-hidden');
                                    if (aria_hidden)
                                    {
                                        aria_hidden == 'true' ?
                                            $target.attr('aria-hidden', 'false') :
                                            $target.attr('aria-hidden', 'true') ;
                                    }
                                    var aria_expanded = $this_single_on.attr('aria-expanded');
                                    if (aria_expanded)
                                    {
                                        aria_expanded == 'true' ?
                                            $this_single_on.attr('aria-expanded', 'false') :
                                            $this_single_on.attr('aria-expanded', 'true') ;
                                    }
                                }
                            }
                        });
                    }
                    
                    
                    //      Custom callback
                    if (options && typeof options.callback === 'function')
                    {
                        try {
                            options.callback($clicked_element, $toggle_target);
                        }
                        catch(e)
                        {
                            //      debug
                            //console.log('Exception in Click on toggle : ');
                            //console.log($clicked_element);
                            //console.log('-> error message :');
                            //console.log(e);
                        }
                    }
                }
            });
        }
    });
};
