
/**
 *  Toggler
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
            
            //      Several triggers for single target
            //      Dummy initial selection
            var $extra_triggers = $this;
            
            //      Reference all other triggers (except itself)
            $triggers.each(function()
            {
                var $iterated_trigger = $(this);
                if ($iterated_trigger.attr('href') == href) {
                    $extra_triggers.add(this);
                }
            });
            
            //      Note : not() accepts Element argument, not jQuery
            //      -> using each() context's "this", alone
            $extra_triggers = $extra_triggers.not(this);
            
            //      Keep these refs on itself
            if ($extra_triggers && $extra_triggers.length) {
                $this.data('extra_triggers', $extra_triggers);
            }
            
            
            /**
             *  Click on toggle
             *  (Event handler)
             */
            $this.click(function(e)
            {
                var $this_clicked = $(this),
                    $target_clicked = $this_clicked.data('toggle_controls'),
                    $extra_triggers_clicked = $this_clicked.data('extra_triggers');
                
                //      Prevent default link behaviour unless allowed in options
                if (!options || !options.no_prevent_default) {
                    e.preventDefault();
                }
                
                if ($target.length)
                {
                    $target_clicked.toggleClass('is-off').toggleClass('is-on');
                    $this_clicked.toggleClass('is-off').toggleClass('is-on');
                    
                    //      Update other "triggers" pointing to the same target
                    if ($extra_triggers_clicked && $extra_triggers_clicked.length)
                    {
                        $extra_triggers_clicked.each(function()
                        {
                            var $extra_trigger = $(this);
                            $extra_trigger.toggleClass('is-off').toggleClass('is-on');
                            var aria_expanded = $extra_trigger.attr('aria-expanded');
                            if (aria_expanded)
                            {
                                aria_expanded == 'true' ?
                                    $extra_trigger.attr('aria-expanded', 'false') :
                                    $extra_trigger.attr('aria-expanded', 'true') ;
                            }
                        });
                    }
                    
                    //      Accessibilité : toggle attribute aria-hidden
                    //      http://www.w3.org/TR/wai-aria/states_and_properties#aria-hidden
                    var aria_hidden = $target_clicked.attr('aria-hidden');
                    if (aria_hidden)
                    {
                        aria_hidden == 'true' ?
                            $target_clicked.attr('aria-hidden', 'false') :
                            $target_clicked.attr('aria-hidden', 'true') ;
                    }
                    
                    //      Accessibilité : toggle attribute aria-expanded
                    //      http://www.w3.org/TR/wai-aria/states_and_properties#aria-expanded
                    var aria_expanded = $this_clicked.attr('aria-expanded');
                    if (aria_expanded)
                    {
                        aria_expanded == 'true' ?
                            $this_clicked.attr('aria-expanded', 'false') :
                            $this_clicked.attr('aria-expanded', 'true') ;
                    }
                    
                    //      Custom callback
                    if (options && typeof options.callback === 'function')
                    {
                        try {
                            options.callback($this_clicked, $target_clicked);
                        }
                        catch(e)
                        {
                            //      debug
                            //console.log('Exception in Click on toggle : ');
                            //console.log($this_clicked);
                            //console.log('-> error message :');
                            //console.log(e);
                        }
                    }
                }
            });
        }
    });
};
