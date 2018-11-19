
/**
 * Toggler jQuery plugin.
 *
 * Binary state change: (de)activates element(s) by clicking on other element(s)
 * bound together using "href" or "aria-controls" attributes.
 *
 * This toggles overridable classes "is-off" and "is-on" on both the clicked
 * elements (= triggers) and their targets. No styling is implemented. It also
 * toggles aria "expanded" and "hidden" attributes + preventDefault() on clicked
 * elements (unless opted-out via options).
 *
 * This state is kept in sync on target(s)/trigger(s) pairs. Multiple triggers
 * and multiple targets - any combinations - are supported for every "batch"
 * (= set of triggers bound together every time this plugin is initialized).
 *
 * By default, keeps only one trigger(s)/target(s) pair active at a time,
 * essentially behaving like radios or tabs.
 *
 * It requires the initial "state" to be correctly represented in HTML before
 * this plugin is used - attributes and classes.
 *
 * @param options
 *   Optional object : {
 *     callback : function called after state change with 3 arguments :
 *       the clicked element (trigger), its target, and the options object.
 *     trigger_kill : function allowing to prevent toggles if it returns false.
 *        It gets 2 arguments : the trigger element, and options object.
 *     no_prevent_default : boolean to avoid preventDefault() on click.
 *     no_single_on : prevents radio-like behavior.
 *     tab_like : boolean to make toggles behave like tabs (once active, stay
 *       active if clicked again - only switch off when clicking on another
 *       toggle). Incompatible with 'no_single_on' option.
 *     trigger_class: object containing overridable CSS classes for triggers.
 *       defaults to: {on: 'is-on', off: 'is-off'}
 *     target_class: object containing overridable CSS classes for targets.
 *       defaults to: {on: 'is-on', off: 'is-off', once: 'has-triggered'}
 *     targets: jQuery element - matches to custom targets. Allows to manually
 *       set target(s) for current trigger(s).
 *   }
 *
 * @example with <a>
 *   JS : $('a[data-toggler]').toggler();
 *   HTML : <a class="is-off" href="#target-by-id" aria-haspopup="true" aria-controls="target-by-id" data-toggler>...</a>
 *   <div class="is-off" id="target-by-id">...</div>
 * @example variant with <button>
 *   JS : $('button[aria-controls]').toggler();
 *   HTML : <button class="is-off" aria-haspopup="true" aria-controls="target-by-id">...</button>
 * @example with custom callback (3 arguments : clicked element, toggle target, options object)
 *   JS : $('a[data-toggler]').toggler({ "callback": my_custom_callback_function });
 *   function my_custom_callback_function($trigger, $target, options) { ... }
 *
 * W3C Recommendation WAI-ARIA references :
 * @see http://www.w3.org/TR/wai-aria/states_and_properties#aria-controls
 * @see http://www.w3.org/TR/wai-aria/states_and_properties#aria-haspopup
 *
 * Source :
 * https://github.com/Paulmicha/snippets/blob/master/Front-end%2FJavascript%2FjQuery%2Ftoggler.js
 */
(function($, undefined) {
  jQuery.fn.toggler = function(options) {

    var $triggers = $(this);
    var default_options = {
      tab_like: false,
      no_single_on: false,
      no_prevent_default: false,
      trigger_class: {on: 'is-on', off: 'is-off'},
      target_class: {on: 'is-on', off: 'is-off', once: 'has-triggered'}
    };

    options = $.extend(default_options, options);

    /**
     * Toggles a single trigger element.
     *
     * @param object $trigger
     *  The trigger jQuery element.
     * @param string new_state (allowed values : 'on' or 'off')
     *  [optional] If provided, forces which state to set.
     */
    var fn_toggle_trigger = function($trigger, new_state) {
      var aria_expanded = $trigger.attr('aria-expanded');
      if (!new_state) {
        new_state = !$trigger.hasClass(options.trigger_class.on) ? 'on' : 'off';
      }
      switch (new_state) {
        case 'on':
          $trigger.removeClass(options.trigger_class.off).addClass(options.trigger_class.on);
          if (aria_expanded) {
            $trigger.attr('aria-expanded', 'true');
          }
          break;
        case 'off':
          $trigger.removeClass(options.trigger_class.on).addClass(options.trigger_class.off);
          if (aria_expanded) {
            $trigger.attr('aria-expanded', 'false');
          }
          break;
      }
    };

    /**
     * Toggles given target(s).
     *
     * @param object $target
     *  The target(s) (jQuery element).
     * @param string new_state (allowed values : 'on' or 'off')
     *  [optional] If provided, forces which state to set.
     */
    var fn_toggle_target = function($target, new_state) {
      var aria_hidden = $target.attr('aria-hidden');
      if (!new_state) {
        new_state = !$target.hasClass(options.target_class.on) ? 'on' : 'off';
      }
      switch (new_state) {
        case 'on':
          $target.removeClass(options.target_class.off).addClass(options.target_class.on);
          if (aria_hidden) {
            $target.attr('aria-hidden', 'false');
          }
          // Some transitions require an additionel class "has-triggered"
          // to properly function. It only needs to exist after the first time the
          // trigger was used.
          if (!$target.hasClass(options.target_class.once)) {
            $target.addClass(options.target_class.once);
          }
          break;
        case 'off':
          $target.removeClass(options.target_class.on).addClass(options.target_class.off);
          if (aria_hidden) {
            $target.attr('aria-hidden', 'true');
          }
          break;
      }
    };

    /**
     * Gets the target(s) from a single trigger element.
     *
     * @param object $trigger
     *  The trigger jQuery element.
     * @return object || boolean
     *  The targeted jQuery element if it exists, or false.
     */
    var fn_get_target = function($trigger) {
      var $target = $trigger.data('toggle_target');
      if ($target && $target.length) {
        return $target;
      }
      var aria_controls = $trigger.attr('aria-controls');
      var target_selector = aria_controls ? ('#' + aria_controls) : $trigger.attr('href');
      return target_selector ? $(target_selector) : false;
    };

    /**
     * Executes the toggle event.
     *
     * @param object $trigger
     *  The trigger jQuery element.
     */
    var fn_exec_event = function($trigger) {
      var $target = fn_get_target($trigger);

      // Optional Tab-like behavior (does nothing if already on).
      if (options.tab_like && !$trigger.hasClass(options.trigger_class.off)) {
        return;
      }
      // Optional Trigger Kill Switch (custom callback to cancel out event).
      if (options.trigger_kill && typeof options.trigger_kill === 'function' && !options.trigger_kill($trigger, options)) {
        return;
      }

      if ($target && $target.length) {
        fn_toggle_target($target);
      }

      fn_toggle_trigger($trigger);

      var other_triggers = $trigger.data('other_triggers');
      var other_triggers_same_target = $trigger.data('other_triggers_same_target');

      if (other_triggers && other_triggers.length) {
        var i = 0;

        // Independently of the "single on" option, all triggers pointing to the
        // same target(s) should always remain in sync.
        if (other_triggers_same_target && other_triggers_same_target.length) {
          var max = other_triggers_same_target.length;
          var new_state_sync = $trigger.hasClass(options.trigger_class.on) ? 'on' : 'off';
          for (i = 0; i < max; i++) {
            fn_toggle_trigger(other_triggers_same_target[i], new_state_sync);
          };
        }

        // Handle the "single on" option - when it IS requested (by default).
        // This allows to keep only one trigger(s)/target(s) pair active at a
        // time, essentially behaving like radios or tabs.
        if (!options.no_single_on) {
          var max = other_triggers.length;
          var new_state_for_others = $trigger.hasClass(options.trigger_class.on) ? 'off' : 'on';

          for (i = 0; i < max; i++) {
            var $other_trigger = other_triggers[i];
            var $other_trigger_target = fn_get_target($other_trigger);

            if ($other_trigger_target && $other_trigger_target.length) {
              fn_toggle_target($other_trigger_target, new_state_for_others);
            }

            fn_toggle_trigger($other_trigger, new_state_for_others);
          };
        }
      }

      // Custom callback.
      if (options.callback && typeof options.callback === 'function') {
        try {
          options.callback($trigger, $target, options);
        }
        catch(e) {
          console.log(e);
        }
      }
    };

    /**
     * Inits a single trigger.
     *
     * @param object $trigger
     *  The trigger jQuery element.
     */
    var fn_init_trigger = function($trigger) {
      var $target = fn_get_target($trigger);

      // Allow option to manually set target(s) for current trigger(s).
      if (!$target && options.targets) {
        $target = options.targets;
      }

      if ($target.length) {
        $trigger.data('toggle_target', $target);

        // All triggers in current "batch" keep 2 lists of references:
        // - Other trigger(s) pointing to different target(s),
        // - Other trigger(s) pointing to the same target(s).
        var other_triggers = [];
        var other_triggers_same_target = [];

        $triggers.each(function() {
          var $iterated_trigger = $(this);

          if ($iterated_trigger[0] !== $trigger[0]) {
            var $iterated_trigger_target = fn_get_target($iterated_trigger);

            if ($iterated_trigger_target && $iterated_trigger_target.length) {
              // Handle multiple targets comparison.
              // See https://stackoverflow.com/a/3856290
              if ($iterated_trigger_target.length == $target.length && $iterated_trigger_target.length == $iterated_trigger_target.filter($target).length) {
                other_triggers_same_target.push($iterated_trigger);
              }
              else {
                other_triggers.push($iterated_trigger);
              }
            }
            else {
              other_triggers.push($iterated_trigger);
            }
          }
        });

        if (other_triggers && other_triggers.length) {
          $trigger.data('other_triggers', other_triggers);
        }
        if (other_triggers_same_target && other_triggers_same_target.length) {
          $trigger.data('other_triggers_same_target', other_triggers_same_target);
        }

        /**
         * The "toggle" is executed when clicking on any one of the triggers.
         */
        $trigger.click(function(e) {
          fn_exec_event($(this));

          // Prevent default link behaviour unless allowed in options.
          if (!options.no_prevent_default) {
            e.preventDefault();
          }
        });
      }
    };

    // Initial setup.
    $triggers.each(function() {
      fn_init_trigger($(this));
    });

  };
})(jQuery);

