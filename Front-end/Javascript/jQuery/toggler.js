
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
                
                if ($target.length)
                {
                    $target_clicked.toggleClass('is-off').toggleClass('is-on');
                    $this_clicked.toggleClass('is-off').toggleClass('is-on');
                    
                    //      debug
                    //console.log('$target');
                    //console.log($target);
                    
                    //      @todo extra triggers aria attributes
                    //      mode rush : for now just classes
                    if ($extra_triggers_clicked && $extra_triggers_clicked.length)
                    {
                        //      debug
                        //console.log('$extra_triggers A');
                        //console.log($extra_triggers);
                        
                        $extra_triggers_clicked.each(function() {
                            $(this).toggleClass('is-off').toggleClass('is-on');
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
                            //      debug ok 2015/03/31 16:57:23
                            //console.log('Exception in Click on toggle : ');
                            //console.log($this_clicked);
                            //console.log('-> error message :');
                            //console.log(e);
                        }
                    }
                }
                
                //      Pas de navigation retour navigateur pour les toggle
                //      (vu que les ancres de ces liens sont généralement pas faites pour ça)
                e.preventDefault();
            });
        }
    });
};


//      update Paul 2015/03/17 13:04:25
//      Ekopolis Agenda Cop21 : initialisations
$(function()
{
    //      Normal
    //      (ex: filtres exposés col de gauche)
    $('a.js-toggler').toggler();
    
    //      Spécial
    //      Besoin de calculer les positions des popups (col de droite)
    $('a.js-popup-cop21').toggler({
        
        /**
         *  Toggler callback
         *  • Positionne la popup + flèche en fonction de l'élément cliqué
         *  • Espace bas col droite (pour éviter de couper les popups)
         *  • Referme les autres popups
         */
        callback: function($clicked_element, $toggle_target)
        {
            //      Spacer col droite
            //      -> doit être positionné ou masqué AVANT les calculs de positions de popup, ci-dessous
            var $spacer = $('#js-popups-cop21-bottom-spacer'),
                $grid_item = $toggle_target.parent();
            
            if ($spacer.length)
            {
                //      Toggle & adjust height based on active popup,
                //      preventing unwanted "piling" of state classes
                if ($toggle_target.hasClass('is-on'))
                {
                    $spacer.height($toggle_target.outerHeight() + 30);
                    if (!$spacer.hasClass('is-on')) {
                        $spacer.addClass('is-on');
                    }
                    $spacer.removeClass('is-off');
                }
                else if ($toggle_target.hasClass('is-off'))
                {
                    $spacer.height('auto');
                    if (!$spacer.hasClass('is-off')) {
                        $spacer.addClass('is-off');
                    }
                    $spacer.removeClass('is-on');
                }
                
                //      Position : move the spacer below current group of 3 items
                //      @see http://redmine.neuros.fr/issues/5209
                
                /**
                 *  https://api.jquery.com/index/ in jQuery 1.2.x
                 */
                var _find_pos = function($obj, $in_elements)
                {
                    var index = false;
                    
                    //      Workaround : testing positions...
                    //var pos_ = $grid_item.position(),
                    
                    $in_elements.each(function(i)
                    {
                        //      These fail:
                        //      @see http://stackoverflow.com/questions/3176962/jquery-object-equality
                        //if ($obj === $(this)) {
                        //if ($.data($obj) === $.data(this)) {
                        //if ($.data($obj) === $.data($(this))) {
                        
                        //      This works:
                        if ($obj[0] === $(this)[0]) {
                            index = i;
                        }
                    });
                    
                    return index;
                };
                
                
                var $sibling_grid_items = $grid_item.parent().children(),
                    index = _find_pos($grid_item, $sibling_grid_items),
                    cols_nb = 3,
                    index_modulo = (index + 1) % cols_nb,
                    shift_amount = cols_nb - index_modulo,
                    $spacer_pos_grid_item = $grid_item;
                
                //      debug
                //console.log('$sibling_grid_items = ');
                //console.log($sibling_grid_items);
                //console.log("index = " + index);
                //console.log("index = " + index);
                //console.log("index_modulo = " + index_modulo);
                
                //      Find after which item we need to insert the spacer
                if ($sibling_grid_items.length > 1
                    && (index + 1) != $sibling_grid_items.length
                    && index_modulo != 0) {
                    $spacer_pos_grid_item = $sibling_grid_items.eq(index + shift_amount);
                }
                
                //      Move spacer
                if ($spacer.hasClass('is-on')) {
                    $spacer_pos_grid_item.after($spacer);
                }
                else if ($spacer.parent().hasClass('o-ibgrid')) {
                    $grid_item.parent().parent().parent().append($spacer);
                }
            }
            
            
            
            //      update Paul 2015/03/31 16:49:57 - quand on clique sur la croix fermer,
            //      le grid item n'est pas le parent
            //if ($clicked_element.attr('title') == "Fermer") {
            //}
            //var $grid_item = $clicked_element.parent(),
            //      -> en fait, prenons le toggle target comme référence : ne varie pas, et surtout,
            //      a aussi comme parent le grid item qu'on veut
            
            //      Positionne la popup + la flèche
            var $fleche = $toggle_target.find('.c-eko-popup__fleche'),
                pos = $grid_item.position(),
                grid_item_width = $grid_item.width(),
                grid_item_outer_height = $grid_item.outerHeight();
            
            $toggle_target.css('top', pos.top + grid_item_outer_height);
            $fleche.css('left', pos.left + (grid_item_width / 2) - ($fleche.width() / 2));
            
            
            //      Referme les autres popups
            jQuery('a.js-popup-cop21').each(function()
            {
                var $this = $(this);
                if ($this.attr('href') != $clicked_element.attr('href') && $this.hasClass('is-on'))
                {
                    //      Refermer la popup qui était ouverte
                    //      -> reproduire le click "à la main"
                    //      @todo method in plugin for that
                    var $target = $this.data('toggle_controls'),
                        $extra_triggers = $this.data('extra_triggers');
                    
                    if ($target.length)
                    {
                        $target.toggleClass('is-off').toggleClass('is-on');
                        $this.toggleClass('is-off').toggleClass('is-on');
                        
                        //      @todo extra triggers aria attributes
                        //      mode rush : for now just classes
                        if ($extra_triggers && $extra_triggers.length)
                        {
                            //      debug
                            //console.log('$extra_triggers B');
                            //console.log($extra_triggers);
                            
                            $extra_triggers.each(function() {
                                $(this).toggleClass('is-off').toggleClass('is-on');
                            });
                        }
                        
                        var aria_hidden = $target.attr('aria-hidden');
                        if (aria_hidden)
                        {
                            aria_hidden == 'true' ?
                                $target.attr('aria-hidden', 'false') :
                                $target.attr('aria-hidden', 'true') ;
                        }
                        var aria_expanded = $this.attr('aria-expanded');
                        if (aria_expanded)
                        {
                            aria_expanded == 'true' ?
                                $this.attr('aria-expanded', 'false') :
                                $this.attr('aria-expanded', 'true') ;
                        }
                    }
                }
            });
        }
    });
});




