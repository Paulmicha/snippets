
/**
 *  Parent or Ancestor element Click Delegation
 *  Trigger click from selected parent or ancestor (closest) element(s) of a link
 *  
 *  @example
 *      HTML : <a href="..." data-pclick='li'>...</a>
 *      JS : $('a[data-pclick]').pclick();
 *  
 *  @todo document options
 *  @see http://api.jquery.com/closest/
 */
jQuery.fn.pclick = function(options)
{
    $ = jQuery;
    $(this).each(function()
    {
        var $this = $(this),
            $proxies = [],
            options = $.extend({}, options),
            selector = (options && options.attr) ? $this.attr(options.attr) : $this.attr('data-pclick');
        
        //      Allow complex selection (callback that returns matched elements)
        if (options.get_targets && typeof options.get_targets === 'function') {
            $proxies = options.get_targets($this);
        }
        //      Allow not using closest()
        else if (options.no_closest && selector) {
            $proxies = $(selector);
        }
        else if (selector) {
            $proxies = $this.closest(selector);
        }
        
        //      Delegate click
        if ($proxies.length > 0)
        {
            $proxies.each(function(i)
            {
                var $proxy = $(this);
                $proxy.css('cursor', 'pointer');
                $proxy.data('proxied_link', $this);
                
                //      @todo remove bubbling up on all links that could exist "under" closest match(es) = $proxy.find('a') ?
                
                /**
                 *  Click on selected Parent or Ancestor element
                 *  (Event handler)
                 */
                $proxy.click(function(e, avoid_recursion)
                {
                    var $proxied_link = $(this).data('proxied_link');
                    if (!avoid_recursion && $proxied_link.length) {
                        $proxied_link.trigger('click', [true]);
                    }
                });
            });
        }
    });
};
