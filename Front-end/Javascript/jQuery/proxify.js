
/**
 *  Proxify
 *  Event "proxying" (or: element "puppetizer")
 *  Manipulation of targets on any event type
 *  
 *  @example
 *      HTML : <a href="..." data-proxy='{"evt_types":"mouseenter mouseleave focus blur","target":".bg-overlay"}'>...</a>
 *      JS : $('[data-proxy]').proxify();
 *  
 *  @example with custom callback & custom data-attr for storing JSON
 *      HTML : <a href="..." data-my-custom-attr='{"evt_types":"mouseenter mouseleave focus blur","target":".bg-overlay"}'>...</a>
 *      JS : 
 *      $('[data-proxy]').proxify({callback:my_custom_fn, attr:"data-my-custom-attr"});
 *      function my_custom_fn(properties)
 *      {
 *          //  Access any properties like :
 *          properties.source : $(this) - in this ex. it corresponds to <a>
 *          properties.targets : in this ex. it's $(".bg-overlay")
 *          properties.options : in this ex. it's {callback:my_custom_fn}
 *      }
 *  
 *  @requires jquery 1.7+
 *  @see http://api.jquery.com/on/
 */
jQuery.fn.proxify = function(options)
{
    $ = jQuery;
    $(this).each(function()
    {
        var $this = $(this),
            json_str = (options && options.attr) ? $this.attr(options.attr) : $this.attr('data-proxy');
        
        //      Support not using JSON in a data-attribute
        //      ex: $('.my-selector').proxify({properties:{evt_types:"mouseenter mouseleave focus blur", target:".bg-overlay"}});
        if (options && options.properties) {
            properties = options.properties;
        }
        else
        {
            try {
                var properties = JSON && JSON.parse(json_str) || $.parseJSON(json_str);
            }
            catch (err)
            {
                //      debug invalid JSON
                //console.log(err);
                return false;
            }
        }
        
        //      We need :
        //      • event type(s) : one or more space-separated event types and optional namespaces, such as "click" or "keydown.myPlugin".
        //      • target(s) : CSS selectors
        //      • [optional] filter : CSS selectors to filter the descendants of the selected elements that trigger the event.
        //      • [optional] callback : a callable function(properties)
        //      • [optional] target toggle class (default : "is-active") : a class that will be added/removed on the target
        //      Limitation : same targets for all event types
        //      @evol introduce variants - ex: using one() To attach an event that runs only once and then removes itself
        if (properties.evt_types && properties.target)
        {
            //      Allow the use of closest() for finding targets
            //      @see http://api.jquery.com/closest/
            if (properties.closest) {
                var $target = $this.closest(properties.target);
            }
            else {
                var $target = $(properties.target);
            }
            
            if ($target.length)
            {
                //      Init defaults
                if (!properties.toggle_class) {
                    properties.toggle_class = "is-active";
                }
                
                //      Handle cursor on targets when pointer events are proxied
                //      + provide an option to opt it out
                if (!properties.no_cursor
                    && (properties.evt_types.match(/click/g)
                    || properties.evt_types.match(/mouse/g))) {
                    $target.css('cursor', 'pointer');
                }
                
                //      Keep stuff for later use
                properties.targets = $target;
                properties.source = $this;
                properties.options = options;
                
                /**
                 *  Attach event listener
                 *  @see http://api.jquery.com/on/
                 */
                $this.on(
                    properties.evt_types,
                    properties.filter,
                    properties,
                    function(e)
                    {
                        e.data.targets.toggleClass(e.data.toggle_class);
                        if (e.data.options && e.data.options.callback && typeof e.data.options.callback === 'function') {
                            e.data.options.callback(e.data);
                        }
                    }
                );
            }
        }
    });
};
