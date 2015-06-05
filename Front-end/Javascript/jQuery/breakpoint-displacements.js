
//  @todo refacto into plugin & "vanilla" JS

//  Breakpoint displacements
//  
//  Using custom data-attributes, move around (back and forth) any element
//  according by breakpoint(s).
//  The element targeted with "dest" acts as a slot, and must already exist.
//  
//  Usage :
//  • Example 1 (default : when current breakpoint matches, append to destination)
//      <div id="my-selector" class="mobile-only"></div>
//      ...
//      <div data-breakpoint-displace='{"mobile":{"dest":"#my-selector"}}' data-breakpoint-current='desktop'> ... </div>
//  
//  • Example 2 (same destination in different breakpoints)
//      <div id="my-selector" class="desktop-hidden"></div>
//      ...
//      <div data-breakpoint-displace='{"mobile,tablet":{"dest":"#my-selector"}}' data-breakpoint-current='desktop'> ... </div>
//  
//  • Example 3 (prepend + with custom callback)
//      <div id="my-selector">
//          <p>This should appear after the displaced item</p>
//      </div>
//      ...
//      <div data-breakpoint-displace='{"mobile":{"dest":"#my-selector","pos":"prepend","callback":"my_custom_fn"}}' data-breakpoint-current='desktop'> ... </div>


/**
 *  Make "displacements" based on specified breakpoint
 *
 *  @param String breakpoint
 */
function breakpoint_displacements(breakpoint)
{
    var $displacements = $('[data-breakpoint-displace]');
    if ($displacements.length > 0)
    {
        $displacements.each(function(i)
        {
            var $this = $(this),
                i = 0,
                bp = '',
                match_found = false,
                breakpoints_arr = [],
                current_state = $this.attr('data-breakpoint-current'),
                json_str = $this.attr('data-breakpoint-displace');

            //  Parse JSON
            try {
                var json_data = JSON && JSON.parse(json_str) || $.parseJSON(json_str);
            }
            catch (err)
            {
                //  debug invalid JSON
                //console.log( err );

                return false;
            }

            //  debug
            //console.log( 'breakpoint = ' + breakpoint );
            //console.log( 'current_state = ' + current_state );
            //console.log( json_data );

            //  1. check if current state is different
            //  2. if need move : wrap in current place (once - to undo afterwards) + setup for next change + move to destination
            //  update 2014/06/11 15:45:03 - allow multiple breakpoints as "key"
            for (bp in json_data)
            {
                breakpoints_arr = [bp];

                if (bp.indexOf(",") > -1) {
                    breakpoints_arr = bp.split(",");
                }

                //  debug
                //console.log( 'breakpoints_arr' );
                //console.log( breakpoints_arr );
                //console.log( "current_state = ", current_state );
                //console.log( "breakpoint = ", breakpoint );

                for (i = 0; i < breakpoints_arr.length; i++)
                {
                    if (breakpoints_arr[ i ] == breakpoint
                        && json_data[ bp ]
                        && json_data[ bp ].dest
                        && current_state
                        && current_state != breakpoint)
                    {
                        //  Detection for replacing at initial position (reversability)
                        //  (see below)
                        match_found = true;

                        //  debug
                        //console.log( 'match_found = ' + match_found );

                        //  Check if need wrapping (to undo later on)
                        if (!$this.hasClass('js-initial-wrap-done'))
                        {
                            //  Once
                            $this.addClass('js-initial-wrap-done');

                            //  Wrap before moving for the first time,
                            //  so that we can easily put it back where it was if needed
                            //  Note the use of our breakpoint-specific visibility utility CSS classes
                            //  update 2014/05/04 14:36:49 - postponed : this prevents correct default behavior (e.g. tablet when only mobile is defined & desktop is initial)
                            //$this.wrap( '<div class="js-initial-wrap ' + current_state + '-only"></div>' );
                            $this.wrap('<div class="js-initial-wrap" data-breakpoint-current="' + breakpoint + '"></div>');

                            //  Keep a reference to this wrapper for easy retrieval later on
                            $this.data('initial-wrap', $this.parent());
                        }

                        //  Move
                        //  Optional position (defaults to 'append')
                        if (json_data[ bp ].pos && json_data[ bp ].pos == 'prepend') {
                            $this.prependTo(json_data[ bp ].dest);
                        }
                        else {
                            $this.appendTo(json_data[ bp ].dest);
                        }

                        //  Callback
                        if (json_data[ bp ].callback && typeof json_data[ bp ].callback === 'function') {
                            json_data[ bp ].callback($this);
                        }
                    }
                }
            }

            //  When no JSON data is found for current breakpoint,
            //  we assume it must go back to its original position
            //  IF current state is different than current breakpoint
            if (!match_found
                && $this.data('initial-wrap')
                && $this.data('initial-wrap').length
                && current_state != breakpoint) {
                $this.appendTo($this.data('initial-wrap'));
            }

            //  Update current state
            $this.attr('data-breakpoint-current', breakpoint);
        });
    }
}

