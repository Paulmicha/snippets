
/**
 *  Toggler
 *  Show / hide content by clicking on matching elements
 *  
 *  @example avec <a>
 *      JS : $('a[data-toggler]').toggler();
 *      HTML : <a class="is-off" href="#target-by-id" aria-haspopup="true" aria-controls="target-by-id" data-toggler>...</a>
 *      <div class="is-off" id="target-by-id">...</div>
 *  @example variante avec <button>
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
	$(this).each(function()
	{
		var $this = $(this),
            href = $this.attr('href'),
            target_selector = href ? href : '#' + $this.attr('aria-controls')
            $target = target_selector ? $(target_selector) : {};
        
        if ($target.length)
        {
            //      Keep as data on toggle for later access
            $this.data('toggle_controls', $target);
            
            
            /**
             *  Click on toggle
             *  (Event handler)
             */
            $this.click(function(e)
            {
                var $this = $(this),
                    $target = $this.data('toggle_controls');
                
                if ($target.length)
                {
                    $target.toggleClass('is-off').toggleClass('is-on');
                    $this.toggleClass('is-off').toggleClass('is-on');
                    
                    //      Accessibilité : toggle attribute aria-hidden
                    //      http://www.w3.org/TR/wai-aria/states_and_properties#aria-hidden
                    var aria_hidden = $target.attr('aria-hidden');
                    if (aria_hidden)
                    {
                        aria_hidden == 'true' ?
                            $target.attr('aria-hidden', 'false') :
                            $target.attr('aria-hidden', 'true') ;
                    }
                    
                    //      Accessibilité : toggle attribute aria-expanded
                    //      http://www.w3.org/TR/wai-aria/states_and_properties#aria-expanded
                    var aria_expanded = $this.attr('aria-expanded');
                    if (aria_expanded)
                    {
                        aria_expanded == 'true' ?
                            $this.attr('aria-expanded', 'false') :
                            $this.attr('aria-expanded', 'true') ;
                    }
                    
                    //      Custom callback
                    if (options && typeof options.callback === 'function') {
                        options.callback($this, $target);
                    }
                }
                
                //      Pas de navigation retour navigateur pour les toggle
                //      (vu que les ancres de ces liens sont généralement pas faites pour ça)
                e.preventDefault();
            });
        }
	});
};
