<?php

/**
 *  Assets-related Drupal 7 snippets
 *  @todo add gotchas
 */

//  Add inline JS in footer
drupal_add_js($js_str, array('type' => 'inline', 'scope' => 'footer'));

//  Add inline CSS
drupal_add_css($css_str, array('type' => 'inline'));

